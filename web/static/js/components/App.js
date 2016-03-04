
import React from 'react';
import Relay from 'react-relay';
import AuthorListItem from './AuthorListItem';


class App extends React.Component {
  render() {
    return (
        <div>
            <h1>Widget list</h1>
            <ul>
              {this.props.store.authors.map((author) => {
                return (
                    <AuthorListItem
                        author={author}
                        kebab={"herp"}
                        key={author.id}
                    />
                  );
              })}
            </ul>
        </div>
    );
  }
}

App.propTypes = {
  store: React.PropTypes.shape({
    authors: React.PropTypes.array({
      name: React.PropTypes.string.isRequired,
    }),
  }),
};

export default Relay.createContainer(App, {
  fragments: {
    store: () => {
      return Relay.QL`
        fragment on Store {
          authors{
            name
            id
          }
        }
      `;
    },
  },
});

const herp = () => 1;
