<?php

declare(strict_types = 1);

const VIDEO_DELIMITER                                = '-';
const PERCENTAGE_VOLUME_DIFFERENCE_TO_START_TRIMMING = 23;
const MIN_VOLUME_TO_START_CUTTING                    = -30;
const CUT_END_VIDEO_CONTAINING                       = '- hasta ';

$videosPath   = $argv[1];
$videosFormat = $argv[2];

$videosFiles  = array_filter(
    array_diff(scandir($videosPath), ['..', '.', '.DS_Store']),
    static function (string $filename) use ($videosFormat) {
        return strstr($filename, $videosFormat);
    }
);
$videos       = array_values(array_reduce($videosFiles, 'video_reducer', []));
$tmpDirectory = "$videosPath/tmp";
$outDirectory = "$videosPath/out";

create_dir($tmpDirectory);
create_dir($outDirectory);

array_walk(
    $videos,
    static function (string $videoName) use ($videosFiles, $videosPath, $tmpDirectory, $outDirectory, $videosFormat) {
        $currentVideoFiles = array_filter(
            $videosFiles,
            static function ($videoFile) use ($videoName) {
                return strstr($videoFile, $videoName);
            }
        );

        video_editor($videoName, $currentVideoFiles, $videosPath, $tmpDirectory, $outDirectory, $videosFormat);
    }
);

remove_dir($tmpDirectory);

simple_log();
simple_log('-------------------------------------------------');
simple_log("🤟  Aaaaaaand, it's done!!! Review all the files!");
exec("open '$outDirectory'");

// ------------- Functions 💩
function video_reducer(array $accumulate, string $videoName): array
{
    $nameParts       = explode(VIDEO_DELIMITER, $videoName);
    $singleVideoName = trim($nameParts[0]);

    return array_merge($accumulate, [$singleVideoName => $singleVideoName]);
}

function video_editor(
    string $videoName,
    array $videoFiles,
    string $videosPath,
    string $tmpDirectory,
    string $outDirectory,
    string $videosFormat
): void {
    h1_log("Working with $videoName");

    $ffmpegConcatenateFilePath = "$tmpDirectory/$videoName.txt";
    $outFilePath               = "$outDirectory/$videoName.$videosFormat";
    $outFilePathReview         = "$outDirectory/$videoName.$videosFormat.txt";
    $tmpVideosFilePaths        = [];

    foreach ($videoFiles as $videoFile) {
        $videoFilePath    = "$videosPath/$videoFile";
        $tmpVideoFilePath = "$tmpDirectory/$videoFile";
        $fileName         = last(explode('/', $videoFile));

        copy($videoFilePath, $tmpVideoFilePath);

        simple_log("📹  $fileName ");
        trim_video_start($tmpVideoFilePath, $tmpDirectory, $videosFormat); // @todo Control "desde" keyword
        trim_video_end($tmpVideoFilePath, $videosFormat); // @todo Control silences at the end

        $tmpVideosFilePaths[] = $tmpVideoFilePath;

        simple_log();
    }

    generate_ffmpeg_concatenate_file($ffmpegConcatenateFilePath, $tmpVideosFilePaths);

    simple_log("🙏  Combining all the parts of $videoName");
    exec("ffmpeg -y -f concat -safe 0 -i '$ffmpegConcatenateFilePath' -c copy '$outFilePath' > /dev/null 2>&1");
    simple_log('🤞  Generating review file');
    generate_review_file($videoName, $tmpVideosFilePaths, $outFilePathReview);
    block_finish_log("🔥  Done! Exported to '$outFilePath'");
}

function trim_video_start(string $videoFile, string $tmpDirectory, string $videosFormat): void
{
    $audioAnalysisPath   = "$tmpDirectory/analysis.txt";
    $cuttedVideoFileName = "$videoFile.cutted_start.$videosFormat";

    tr_log('Analyzing when it should start');
    exec(
        "ffmpeg -t 10 -i '$videoFile' -af astats=metadata=1:reset=1,ametadata=print:key=lavfi.astats.Overall.RMS_level:file='$audioAnalysisPath' -f null - > /dev/null 2>&1"
    );

    $secondToStartCutting = analyze_second_to_start_cutting($audioAnalysisPath);

    tr_log('Cutting it!');
    exec(
        "ffmpeg -y -ss $secondToStartCutting -i '$videoFile' -c copy '$cuttedVideoFileName' > /dev/null 2>&1"
    );

    unlink($videoFile);
    rename($cuttedVideoFileName, $videoFile);
}

function analyze_second_to_start_cutting(string $audioAnalysisPath): float
{
    $data       = array_chunk(explode("\n", file_get_contents($audioAnalysisPath)), 2);
    $parsedData = [];

    foreach ($data as $dataRow) {
        if (isset($dataRow[1])) {
            $seconds = (float) explode('pts_time:', $dataRow[0])[1];
            $volume  = (float) explode('RMS_level=', $dataRow[1])[1];

            $parsedData["'$seconds'"] = $volume;
        }
    }

    $lastVolume = null;
    $lastSecond = 0;
    foreach ($parsedData as $second => $volume) {
        if (null === $lastVolume) {
            $lastVolume = $volume;
        }

        if ($volume > $lastVolume && $volume > MIN_VOLUME_TO_START_CUTTING) {
            $volumeDifference = $lastVolume - $volume;
            $volumeAverage    = $lastVolume + $volume / 2;

            $percentageDifference = abs($volumeDifference / $volumeAverage * 100);

            if ($percentageDifference > PERCENTAGE_VOLUME_DIFFERENCE_TO_START_TRIMMING) {
                return (float) str_replace("'", '', $second);
            }
        }

        $lastVolume = $volume;
        $lastSecond = $second;
    }

    return (float) str_replace("'", '', $lastSecond);
}

function trim_video_end(string $videoFile, string $videosFormat)
{
    $cuttedVideoFileName = "$videoFile.cutted_end.$videosFormat";

    if (strpos($videoFile, CUT_END_VIDEO_CONTAINING) !== false) {
        [$cutUntilMinute, $cutUntilSecond] = explode(
            '.',
            last(explode(CUT_END_VIDEO_CONTAINING, str_replace(".$videosFormat", '', $videoFile)))
        );

        tr_log(sprintf('Needs to be cut at %02d:%02d', $cutUntilMinute, $cutUntilSecond));
        exec(
            sprintf(
                "ffmpeg -i '%s' -to 00:%02d:%02d -c copy '%s'> /dev/null 2>&1",
                $videoFile,
                $cutUntilMinute,
                $cutUntilSecond,
                $cuttedVideoFileName
            )
        );

        unlink($videoFile);
        rename($cuttedVideoFileName, $videoFile);
    }
}

function generate_ffmpeg_concatenate_file(string $filePath, array $tmpVideosFilePaths): void
{
    $content = implode(
        "\n",
        array_map(
            static function (string $videoFile) {
                return "file '$videoFile'";
            },
            $tmpVideosFilePaths
        )
    );

    file_put_contents($filePath, $content);
}

function generate_review_file(string $videoName, array $videosFilePaths, string $outFilePathReview)
{
    $contents        = "$videoName\n\n";
    $totalVideoTime  = 0;
    $previousMinutes = 0;
    $previousSeconds = 0;
    foreach ($videosFilePaths as $video) {
        $videoPartName = last(explode('/', $video));

        exec(
            "ffmpeg -i '$video' 2>&1 | grep \"Duration\"| cut -d ' ' -f 4 | sed s/,// | sed 's@\..*@@g' | awk '{ split($1, A, \":\"); split(A[3], B, \".\"); print 3600*A[1] + 60*A[2] + B[1] }'",
            $videoDurationInSeconds
        );

        $totalVideoTime += last($videoDurationInSeconds);

        $minutesAndSeconds = $totalVideoTime / 60;
        $minutes           = (int) $minutesAndSeconds;
        $seconds           = ($minutesAndSeconds - $minutes) * 60;

        $contents .= sprintf("%02d:%02d --> %s\n", $previousMinutes, $previousSeconds, $videoPartName);

        $previousMinutes = $minutes;
        $previousSeconds = $seconds;
    }

    file_put_contents($outFilePathReview, $contents);
}

function create_dir(string $path): void
{
    if (!@mkdir($path) && !is_dir($path)) {
        throw new RuntimeException(sprintf('Directory "%s" was not created', $path));
    }
}

function remove_dir(string $path): void
{
    exec("rm -rf '$path'");
}

function last(array $array)
{
    return array_values(array_slice($array, -1))[0];
}

function simple_log(string $message = '')
{
    echo "$message\n";
}

function tr_log(string $message)
{
    simple_log("  - $message");
}

function block_finish_log(string $message)
{
    simple_log($message);
    simple_log();
}

function h1_log(string $message)
{
    $formattedMessage = "---   $message   ---";
    $separator        = str_repeat('-', count(mb_split('.', $formattedMessage)));

    simple_log($separator);
    simple_log(" $formattedMessage");
    simple_log($separator);
}
