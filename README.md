# Ansible playbooks for isucon

## テンプレートから生成後にやること

### ansibleのインストール

```
make deps
```

## 当日やること

### 対象ホストの記述

`ssh_config`を書く

issueにssh configを書いて貼るので各自でssh configに追記する

### デプロイ対象の設定

各自自分の決められたホストを設定する

- taxio: isu1
- shanpu: isu2
- pudding: isu3

```
echo isu1 > TARGET
```

## デプロイ方法

### 今の状態をデプロイする

未コミットの内容もデプロイされる

```
make deploy
```

### 特定のブランチをデプロイ

stashしてpullしてcheckoutする。Untrackedなファイルが含まれてしまうので注意。

```
BRANCH=
make deploy-${BRANCH}
```

## その他

### ベンチマーク前にログをローテートする

```
make before-bench
```

### アプリのコード入手ワンライナー

`/home/isucon/isucari/webapp` を取得したい場合

```
ssh isu1 "tar czf - -C ~/isucari webapp" | tar zxf -
```

これでカレントディレクトリに `isucari` ディレクトリができ、全ファイルがコピーされる。

### ミドルウェア関連ファイルのバックアップ

SSHしてバックアップするディレクトリ、ファイルを確認し `inventories/host_vars/ホスト名.yml` に書く。

```
make backup
```

