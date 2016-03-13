
import React from 'react';
import Relay from 'react-relay';
import Link from './Link';
import CreateLinkMutation from '../mutations/CreateLinkMutation';

class App extends React.Component {
  static propTypes = {
    limit: React.PropTypes.number,
  }

  handleSearch = (e) => {
    const query = e.target.value;
    this.props.relay.setVariables({ query})
  }

  setLimit = (e) => {
    const newLimit = Number(e.target.value);
    this.props.relay.setVariables({limit: newLimit});
  }

  handleSubmit = (e) => {
    e.preventDefault();
    Relay.Store.commitUpdate(
      new CreateLinkMutation({
        title: this.newTitle.value,
        url: this.newUrl.value,
        store: this.props.store,
      })
    );
    this.newTitle.value = '';
    this.newUrl.value = '';
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
            <form onSubmit={this.handleSubmit}>
                <input placeholder="Title"
                    ref={(c) => (this.newTitle = c)}
                    type="text"
                />
                <input placeholder="Title"
                    ref={(c) => (this.newUrl = c)}
                    type="text"
                />
                <button type="submit">Add</button>
            </form>
            Showing: &nbsp;
            <input placeholder="Serach"
                type="text"
                onChange={this.handleSearch}
            />
            <select onChange={this.setLimit}
                defaultValue={this.props.relay.variables.limit}>
                <option value="5">5</option>
                <option value="10">10</option>
            </select>
            <ul>{content}</ul>
        </div>
      );
  }
}

export default Relay.createContainer(App, {
  initialVariables:{
    limit: 10,
    query: '',
  },
  fragments: {
    store: () => {
      return Relay.QL`
        fragment on Store {
          id,
          linkConnection(first: $limit, query: $query) {
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
