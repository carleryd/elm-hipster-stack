import React from 'react';
import Relay from 'react-relay';
import moment from 'moment';
import urlPrettify from '../shared/urlPrettify';

class Link extends React.Component {
  dateStyle = () => ({
    color: '#888',
    fontSize: '0.7em',
    marginRight: '0.5em',
  });

  urlStyle = () => ({
    color: '#062',
    fontSize: '0.85em',
  });


  dateLabel = () => {
    const { link , relay } = this.props;
    if (relay.hasOptimisticUpdate(link)) {
      return 'Saveing...';
    }
    return moment(link.createdAt).format('L');
  };

  render() {
    let { link } = this.props;
    return (
        <li>
            <div
                className="card-panel"
                style={{ padding: '1em' }}
            >
                <a
                    href={link.url}
                    target="_blank"
                >
                  {link.title}
                </a>
                <div className="truncate">
                    <span style={this.dateStyle()}>
                      {this.dateLabel()}
                    </span>
                    <a
                        href={link.url}
                        style={this.urlStyle()}
                    >
                      {urlPrettify(link.url)}
                    </a>
                </div>
            </div>
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
