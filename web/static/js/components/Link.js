import React from 'react';
import Relay from 'react-relay';

class Link extends React.Component {
  render() {
    const { link } = this.props;
    return (
        <li>
            <a href={link.url}>{link.title}</a>
        </li>
    );
  }
}

export default Relay.createContainer(Link, {
  fragments:{
    link: () => {
      return Relay.QL`
        fragment on Link {
          url,
          title,
        }
      `;
    },
  },
});
