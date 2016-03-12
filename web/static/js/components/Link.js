import React from 'react';
import Relay from 'react-relay';
import moment from 'moment';

class Link extends React.Component {
  dateStyle = () => ({
    color: '#888',
    fontSize: '0.7em',
    marginRight: '0.5em',
  });


  dateLabel = () => moment(this.props.link.createdAt).format('L')

  render() {
    const { link } = this.props;
    return (
        <li>
            <span style={this.dateStyle()}>
              {this.dateLabel()}
            </span>
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
          createdAt,
        }
      `;
    },
  },
});
