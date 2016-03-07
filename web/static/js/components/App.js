
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
    const derp = this.props.store.links;
    const content = derp.map((link) => {
      return (
          <Link key={link.id}
              link={link}
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
          # Fetch 5 links only
          links {
            id,
            ${Link.getFragment('link')}
          }
        }
      `;
    },
  },
});
