# Phoenix hipster stack!
* [Phoenix] (http://www.phoenixframework.org/)
* [React] (https://facebook.github.io/react/)
* [Relay](https://facebook.github.io/relay/)
* [GraphQL](https://github.com/facebook/graphql)
* [RethinkDB](https://www.rethinkdb.com/)
* [Webpack](https://webpack.github.io/)
  * Hot module reload
* [Immutable.js](https://facebook.github.io/immutable-js/)
* [Flow](http://flowtype.org/)
* [Eslint](http://eslint.org/)
* [Jest](https://facebook.github.io/jest/)
* [Docker](https://www.docker.com/)

### Example app
Phoenix hipster stack commes with an example app [SEE IT HERE](http://phoenix-hipster-stack.ventureinto.space/).

The app is a port of the node.js app built in the [Building Data-driven React Applications with Relay, GraphQL, and Flux](http://app.pluralsight.com/courses/react-apps-with-relay-graphql-flux) course from Pluralsight.
The app is running on a 512mb single core droplet on digitalocean.

### Getting Started

Clone this repo then:

1. Install dependencies with `mix deps.get && npm i`
2. Start rethinkDB `rethinkdb`
3. Start Phoenix endpoint with `mix phoenix.server`
4. Create database by going to `localhost:4000/reset`
5. Visit `localhost:4000/graphql` to test the amazing graphiql interface
6. Query the database
  ```
  query myQuery{
    store{
      authors {
        id
        name
      }
    }
  }
  
  ```
7. Visit `localhost:4000` for a basic relay app using the data.

**Jest is not implemented. Feel free to contribute :)**

## DOCKER 
1. `docker-compose build`
2. `docker-compose up`
3. `visit localhost:4001/reset`
4. `visit localhost:4001`

## Make your own project
1. `git clone git@github.com:graphql-elixir/phoenix-hipster-stack.git <name-of-your-project>`
2. `cd <name-of-your-project> rm -rf .git`
3. `git init`
4. `git remote add orgin <your-new-repo>`
5. `git push -u orgin master`

When changeing the graphql schemas run 
`mix CreateSchema` to make a new `schema.json`. 
This `schema.json` is used by Relay.


## Running in production.
```
MyAwesomePrompt> MIX_ENV=prod mix compile
MyAwesomePrompt> MIX_ENV=prod mix phoenix.digest
MyAwesomePrompt> MIX_ENV=prod PORT=4000 mix phoenix.server
```


###Used resourses
* [updated-phoenix-webpack-react-setup](http://mikker.github.io/2016/02/04/updated-phoenix-webpack-react-setup.html)
* GraphQL & RethinkDB
  * [GraphQL-Elixir](https://github.com/joshprice/graphql-elixir)
  * [plug_GraphQL](https://github.com/joshprice/plug_graphql)
  * [graphql-phoenix-rethinkdb] (https://github.com/AdamBrodzinski/graphql-phoenix-rethinkdb)
  * [phoenix-rethinkdb-example](https://github.com/AdamBrodzinski/phoenix-rethinkdb-example)

