codely::list_courses() {
  curl -s 'https://pro.codely.tv/api/private/library/resource/?page_size=50&page=1&ordering=featured&order=featured&type=course&filters%5Border%5D=featured&filters%5Btype%5D=course' |
    jq -j '.results | .[] |.url,";", .name,"\n"' |
    sed 's/"//g'
}
