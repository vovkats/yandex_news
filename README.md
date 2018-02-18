# README
Read the manual 

## HOW TO RUN APP
* Run
```
bundle install
```

```
yarn install
```

```
cp config/secrets.example.yml config/secrets.yml
```

```
cp config/database.example.yml config/database.yml
```

```
cp config/cable.example.yml config/cable.yml
```

```
rake db:{drop,create,migrate}
```
```
rake db:seed
```
```
foreman start
```

## User credentials
`email: user@example.com`
`password: rootroot`

## Requirements
redis, ruby, yarn, node