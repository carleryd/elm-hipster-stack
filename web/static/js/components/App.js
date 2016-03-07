
import React from 'react';
import Relay from 'react-relay';
import AuthorListItem from './AuthorListItem';
import Link from './Link';


class App extends React.Component {
  static propTypes = {
    limit: React.PropTypes.number,
  }

  setLimit = (e) => {
    const newLimit = Number(e.target.value);
    this.props.relay.setVariables({limit: newLimit});
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
            Showing: &nbsp;
            <select onChange={this.setLimit}>
                <option value="5">5</option>
                <option value="10" selected>10</option>
            </select>
            <ul>{content}</ul>
        </div>
      );
  }
}

export default Relay.createContainer(App, {
  initialVariables:{
    limit: 10,
  },
  fragments: {
    store: () => {
      return Relay.QL`
        fragment on Store {
          linkConnection(first: $limit) {
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
