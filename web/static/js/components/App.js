
import React from 'react';
import Relay from 'react-relay';
import AuthorListItem from './AuthorListItem';


class App extends React.Component {
  static propTypes = {
    limit: React.PropTypes.number,
  }

  static defaultProps = {
    limit: 5,
  }


  render() {
    const derp = this.props.store.links.slice(0, this.props.limit);
    const content = derp.map((link) => {
      return (
          <li key={link.id}>
              <a href={link.url}>{link.title}</a>
          </li>
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
          links {
            title
            url
            id
          }
        }
      `;
    },
  },
});
