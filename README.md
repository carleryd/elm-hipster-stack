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

## Make your own project
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

