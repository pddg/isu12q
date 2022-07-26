# Access Log

## nginxのアクセスログの場所

`/var/log/nginx/access.log` にある。

## nginxのログフォーマット

alpで解析するためにnginxのログフォーマットをLTSVにする必要がある。以下のフォーマットをコピーして `/etc/nginx/nginx.conf` にある既存のログフォーマットを書き換える。

```
    log_format main "time:$time_local"
                    "\thost:$remote_addr"
                    "\tforwardedfor:$http_x_forwarded_for"
                    "\treq:$request"
                    "\tstatus:$status"
                    "\tmethod:$request_method"
                    "\turi:$request_uri"
                    "\tsize:$body_bytes_sent"
                    "\treferer:$http_referer"
                    "\tua:$http_user_agent"
                    "\treqtime:$request_time"
                    "\tcache:$upstream_http_x_cache"
                    "\truntime:$upstream_http_x_runtime"
                    "\tapptime:$upstream_response_time"
                    "\tvhost:$host";
```

## alpでの解析

以下のコマンドを実行する。

```
cat /var/log/nginx/access.log | alp ltsv -r | less
```

例えば以下の様な結果が出る

```
+-------+-----+-----+-----+-----+-----+--------+-------------------------------+-------+-------+---------+-------+-------+-------+-------+--------+-----------+-----------+--------------+-----------+
| COUNT | 1XX | 2XX | 3XX | 4XX | 5XX | METHOD |              URI              |  MIN  |  MAX  |   SUM   |  AVG  |  P90  |  P95  |  P99  | STDDEV | MIN(BODY) | MAX(BODY) |  SUM(BODY)   | AVG(BODY) |
+-------+-----+-----+-----+-----+-----+--------+-------------------------------+-------+-------+---------+-------+-------+-------+-------+--------+-----------+-----------+--------------+-----------+
| 977   | 0   | 975 | 0   | 2   | 0   | GET    | /api/estate/search            | 0.064 | 0.544 | 154.754 | 0.158 | 0.232 | 0.252 | 0.280 | 0.049  | 0.000     | 30793.000 | 16316579.000 | 16700.695 |
| 742   | 0   | 741 | 0   | 1   | 0   | GET    | /api/chair/search             | 0.088 | 0.512 | 128.043 | 0.173 | 0.252 | 0.268 | 0.308 | 0.053  | 0.000     | 15566.000 | 11013387.000 | 14842.840 |
| 373   | 0   | 372 | 0   | 1   | 0   | GET    | /api/chair/low_priced         | 0.020 | 0.192 | 33.076  | 0.089 | 0.124 | 0.136 | 0.168 | 0.027  | 0.000     | 12135.000 | 4509152.000  | 12088.879 |
| 373   | 0   | 371 | 0   | 2   | 0   | GET    | /api/estate/low_priced        | 0.024 | 0.240 | 28.773  | 0.077 | 0.116 | 0.128 | 0.160 | 0.027  | 0.000     | 13340.000 | 4943866.000  | 13254.332 |
| 165   | 0   | 165 | 0   | 0   | 0   | GET    | /api/estate/search/condition  | 0.000 | 0.008 | 0.100   | 0.001 | 0.004 | 0.004 | 0.004 | 0.002  | 2563.000  | 2563.000  | 422895.000   | 2563.000  |
| 124   | 0   | 124 | 0   | 0   | 0   | GET    | /api/chair/search/condition   | 0.000 | 0.008 | 0.084   | 0.001 | 0.004 | 0.004 | 0.008 | 0.002  | 3392.000  | 3392.000  | 420608.000   | 3392.000  |
| 88    | 0   | 83  | 0   | 5   | 0   | POST   | /api/estate/nazotte           | 0.084 | 2.001 | 38.300  | 0.435 | 1.056 | 1.999 | 2.001 | 0.506  | 34.000    | 33863.000 | 1089354.000  | 12379.023 |
| 19    | 0   | 19  | 0   | 0   | 0   | GET    | /api/estate/7255              | 0.004 | 0.012 | 0.084   | 0.004 | 0.012 | 0.012 | 0.012 | 0.005  | 622.000   | 622.000   | 11818.000    | 622.000   |
| 18    | 0   | 18  | 0   | 0   | 0   | GET    | /api/estate/20819             | 0.000 | 0.016 | 0.060   | 0.003 | 0.016 | 0.016 | 0.016 | 0.005  | 580.000   | 580.000   | 10440.000    | 580.000   |
| 16    | 0   | 16  | 0   | 0   | 0   | GET    | /api/estate/2859              | 0.000 | 0.028 | 0.064   | 0.004 | 0.008 | 0.028 | 0.028 | 0.007  | 665.000   | 665.000   | 10640.000    | 665.000   |
| 13    | 0   | 13  | 0   | 0   | 0   | GET    | /api/estate/20621             | 0.004 | 0.012 | 0.032   | 0.002 | 0.004 | 0.012 | 0.012 | 0.003  | 661.000   | 661.000   | 8593.000     | 661.000   |
...
```

### 解析結果の読み方

自明な物は除く。

| 項目 | 意味する物 | 備考 |
| ---- | ---------- | ---- |
| MIN | 最小レスポンス時間（sec） | |
| MAX | 最大レスポンス時間（sec） | |
| SUM | 合計レスポンス時間（sec） | |
| AVG | 平均レスポンス時間（sec） | |
| P90 | レスポンス時間の90パーセンタイル | `--percentiles`オプションで指定できる |
| P95 | レスポンス時間の95パーセンタイル | `--percentiles`オプションで指定できる |
| P99 | レスポンス時間の99パーセンタイル | `--percentiles`オプションで指定できる |
| STDDEV | レスポンス時間の標準偏差 | |

`(BODY)` とついているものはリクエストボディのサイズを表す。単位は byte 。

### ソート順を変える

デフォルトは `count` つまりそのエンドポイントを叩かれた回数の順になっている。`--sort` オプションで変更できる（例：`--sort=count`）。

指定できる値一覧

- `max`
- `min`
- `sum`
- `avg`
- `max-body`
- `min-body`
- `sum-body`
- `avg-body`
- `p90`
- `p95`
- `p99`
- `stddev`
- `uri`
- `method`

### エンドポイントをまとめる

例えば `/api/estate/[0-9]*` にマッチするエンドポイントをまとめて表示したいとする。
以下の様にオプションを指定する。

```
cat /var/log/nginx/access.log | alp ltsv -m '/api/estate/[0-9]*' -r | less
```

以下の様にまとめられる。

```
+-------+-----+------+-----+-----+-----+--------+-------------------------------+-------+-------+---------+-------+-------+-------+-------+--------+-----------+-----------+--------------+-----------+
| COUNT | 1XX | 2XX  | 3XX | 4XX | 5XX | METHOD |              URI              |  MIN  |  MAX  |   SUM   |  AVG  |  P90  |  P95  |  P99  | STDDEV | MIN(BODY) | MAX(BODY) |  SUM(BODY)   | AVG(BODY) |
+-------+-----+------+-----+-----+-----+--------+-------------------------------+-------+-------+---------+-------+-------+-------+-------+--------+-----------+-----------+--------------+-----------+
| 2143  | 0   | 2137 | 0   | 6   | 0   | GET    | /api/estate/[0-9]*            | 0.048 | 0.544 | 188.015 | 0.088 | 0.192 | 0.228 | 0.268 | 0.078  | 0.000     | 30793.000 | 22067306.000 | 10297.390 |
| 742   | 0   | 741  | 0   | 1   | 0   | GET    | /api/chair/search             | 0.088 | 0.512 | 128.043 | 0.173 | 0.252 | 0.268 | 0.308 | 0.053  | 0.000     | 15566.000 | 11013387.000 | 14842.840 |
| 427   | 0   | 422  | 0   | 5   | 0   | POST   | /api/estate/[0-9]*            | 0.000 | 2.001 | 39.040  | 0.091 | 0.200 | 0.504 | 1.999 | 0.289  | 0.000     | 33863.000 | 1089354.000  | 2551.180  |
```

複数指定したい場合はカンマ区切りで指定する。

```
cat /var/log/nginx/access.log | alp ltsv -m '/api/estate/[0-9]*,/api/chair/[0-9]*' -r | less
```

### クエリパラメータを表示したい

デフォルトではクエリパラメータは省略されて集計される。`-q` を付けることで表示できる。

```
cat /var/log/nginx/access.log | alp ltsv -q -r | less
```

### 結果を比較する

改善後に実際にレスポンス時間等が改善したかを知りたくなるケースがある。
注意：ベンチマーク前にログをローテートしておかないと結果が混ざってしまう。

あらかじめ前回の結果のダンプを取得しておく。

```
cat /var/log/nginx/access.log | alp ltsv -r -d /tmp/dump-previous.yaml > /dev/null
```

もしくは、ローテートした後に取得することもできる。

```
cat /var/log/nginx/access.log.1 | alp ltsv -r -d /tmp/dump-previous.yaml > /dev/null
```

今回の結果のダンプを得る。

```
cat /var/log/nginx/access.log | alp ltsv -r -d /tmp/dump-current.yaml > /dev/null
```

結果を比較する。

```
alp diff /tmp/dump-previous.yaml /tmp/dump-current.yaml | less
```

## アクセスログのローテーション

前回のベンチマークの結果と混ざらないように、ベンチマークを実行する前に以下のコマンドを実行してアクセスログの中身を消去する。

```
make before-bench
```

これにより、以降のログは `/var/log/nginx/access.log` に書き込まれ、古いログは順に `/var/log/nginx/access.log.1` などのように世代番号の数値のサフィックスが付与されて残る。
デフォルトでは十世代分のログが保存される。

もし何らかの事情によりNginxのホスト上で直接ローテーションしたい場合、以下のコマンドを実行する。

```
sudo logrotate -f /etc/logrotate.d/nginx
```
