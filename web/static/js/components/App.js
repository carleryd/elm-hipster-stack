
import React from 'react';
import Relay from 'react-relay';
import Link from './Link';
import { debounce } from 'lodash';
import CreateLinkMutation from '../mutations/CreateLinkMutation';

class App extends React.Component {
  static propTypes = {
    limit: React.PropTypes.number,
  }

  constructor(props) {
    super(props);
    this.search = debounce(this.search,300);
  }


  handleSearch = (e) => {
    this.search(e.target.value);
  };

  search = (query) => {
   this.props.relay.setVariables({ query });
  };

  handleSetLimit = (e) => {
    const newLimit = Number(e.target.value);
    this.props.relay.setVariables({limit: newLimit});
  }

  handleSubmit = (e) => {
    e.preventDefault();
    const onSuccess = () => {
      $('#modal').closeModal();
    };

    const onFailure = (transaction) => {
      const error = transaction.getError() || new Error('Mutation failed.');
      console.log(error);
    };

    Relay.Store.commitUpdate(
      new CreateLinkMutation({
        title: this.newTitle.value,
        url: this.newUrl.value,
        store: this.props.store,
      }),
      { onFailure, onSuccess }
    );
    this.newTitle.value = '';
    this.newUrl.value = '';
  }

  componentDidMount() {
    $('.modal-trigger').leanModal();
  }

  render() {
    const edges = this.props.store.linkConnection.edges;
    const content = edges.map((edge) => {
      return (
          <Link
              key={edge.node.id}
              link={edge.node}
          />
      );
    });

    return (
        <div>
            <div className="input-field">
                <input
                    id="search"
                    type="text"
                    onChange={this.handleSearch}
                />
                <label htmlFor="search">Search All Resources</label>
            </div>

            <div className="row">
                <a
                  className="waves-effect waves-light btn modal-trigger right light-blue white-text"       href="#modal"
                >Add New Resource
                </a>
            </div>

            <ul>
              {content}
            </ul>

            <div className="row">
                <div className="col m9 s12">
                    <div className="flow-text">
                        <a
                            href="https://twitter.com/RGRjs"
                            target="_blank"
                        >
                          @RGRjs
                        </a>
                    </div>
                </div>
                <div className="col m3 hide-on-small-only">
                    <div className="input-field">
                        <select
                            className="browser-default"
                            defaultValue={this.props.relay.variables.limit}
                            id="showing"
                            onChange={this.handleSetLimit}
                        >
                            <option value="10">Show 10</option>
                            <option value="25">Show 25</option>
                            <option value="50">Show 50</option>
                            <option value="100">Show 100</option>
                        </select>
                    </div>
                </div>
            </div>

            <div
                className="modal modal-fixed-footer"
                id="modal"
            >
                <form onSubmit={this.handleSubmit}>
                    <div className="modal-content">
                        <h5>Add New Resource</h5>
                        <div className="input-field">
                            <input
                                className="validate"
                                id="newTitle"
                                ref={(c) => (this.newTitle = c)}
                                required
                                type="text"
                            />
                            <label htmlFor="newTitle">
                              Title
                            </label>
                        </div>
                        <div className="input-field">
                            <input
                                className="validate"
                                id="newUrl"
                                ref={(c) => (this.newUrl = c)}
                                required
                                type="url"
                            />
                            <label htmlFor="newUrl">
                              Url
                            </label>
                        </div>
                    </div>
                    <div className="modal-footer">
                        <button
                            className="waves-effect waves-green btn-flat green darken-3 white-text"
                            type="submit"
                        >
                            <strong>
                              Add
                            </strong>
                        </button>
                        <a
                            className="modal-action modal-close waves-effect waves-red btn-flat"
                            href="#!"
                        >
                          Cancel
                        </a>
                    </div>
                </form>
            </div>
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
