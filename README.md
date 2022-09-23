# gitlab-sample

## run

```bash
make up

make password
# http://localhost:9080でroot + 表示されたパスワードを入力しサインイン

# Admin -> Runner -> Register an instance runnerからトークンを取得
make register
```

## setup

```bash
make keygen

git config --global user.name "jyury11"
git config --global user.email "jyury11@example.com"
```
