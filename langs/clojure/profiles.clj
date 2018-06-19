{:user {:plugins [[lein-midje "3.1.3"]
                  [venantius/ultra "0.4.0"]
                  [com.jakemccrary/lein-test-refresh "0.14.0"]]}
 :test-refresh {:notify-command ["terminal-notifier" "-title" "Tests" "-message"]
                :quiet true}}
