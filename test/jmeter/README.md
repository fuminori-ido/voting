# The Result of Stress Test by JMeter

## Test environment

App:

* OS:         Ubuntu 24 LTS
* CPU:        4-core vm under 12th Gen Intel(R) Core(TM) i7-12700K
* Memory:     4GB
* Language:   ruby  v3.4.5
* Framework:  rails v8.0.2
* Web server: Apache v2.4 + puma v6.6

DB (different vm instance from App):

* OS:         Ubuntu 24 LTS
* CPU:        4-core vm under 12th Gen Intel(R) Core(TM) i7-12700K
* Memory:     4GB
* DB ;        MySQL 8.0

## Scenario

* Data is loaded from test/fixtures.
* N users access(http 'get') to 'voting' page and vote(http 'post') in 60 sec.
* N = 600, 1000, 2000, 6000

## Result
### Conclusion

* "600 users / 1 min." can be processed by 4 core CPU x 4 GB memory.
* As of (10, 4) (see below), the bottleneck is CPU core.

### (apache servers, puma workers) = (10 4)

jmeter summary:

| N<br>[users]  | get<br>err% | get<br>tp(*)[/sec]  | post<br>err%  | post<br>tp[/sec]  |
| --------:     | --------:   | --------------:     | --------:     | ------------:     |
|  600          |  0.00       |   10.0              |   0.00        |   10.0            |
| 1000          |  0.00       |   16.7              |   0.50        |   16.7            |
| 2000          |  0.00       |   33.1              |   1.70        |   33.2            |
| 6000          | 22.65       |   31.7              |  23.93        |   31.8            |

* (*) tp:         throughput
* App
  * CPU usage:      60..100 [%/core]    (30% idle)
  * memory usage:   1GB
  * swap usage:     0GB
* DB
  * CPU usage:      ~50 [%/core]        (21% idle)
  * memory usage:   0.8GB
  * swap usage:     0GB

### (apache servers, puma workers) = (1, 1)

(reference purpose only)

jmeter summary:

| N<br>[users]  | get<br>err% | get<br>tp(*)[/sec]  | post<br>err%  | post<br>tp[/sec]  |
| --------:     | --------:   | --------------:     | --------:     | ------------:     |
|  600          |  0.00       |    9.8              |   0.00        |    9.8       |
| 1000          |  0.00       |    9.5              |   0.90        |    9.5            |
| 2000          |  4.65       |   11.2              |   4.95        |   11.2            |
| 6000          | 62.92       |   20.8              |  63.20        |   20.8            |

