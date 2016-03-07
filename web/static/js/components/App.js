
import React from 'react';
import Relay from 'react-relay';
import AuthorListItem from './AuthorListItem';
import Link from './Link';


class App extends React.Component {
  static propTypes = {
    limit: React.PropTypes.number,
  }

  static defaultProps = {
    limit: 5,
  }


  render() {
    const derp = this.props.store.linkConnection.edges;
    const content = derp.map((edge) => {
      return (
          <Link key={edge.node.id}
              link={edge.node}
          />
      );
    });

    return (
        <div>
            <h3>Links</h3>
            <ul>{content}</ul>
        </div>
      );
  }
}

export default Relay.createContainer(App, {
  fragments: {
    store: () => {
      return Relay.QL`
        fragment on Store {
          linkConnection(first:2) {
            edges{
              node{
                id,
                ${Link.getFragment('link')}
              }
            }
          }
        }
      `;
    },
  },
});
