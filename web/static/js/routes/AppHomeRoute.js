import Relay from 'react-relay';

export default class extends Relay.Route {
  constructor(props) {
    super(props);
  }
  static queries = {
    store: (Component) => Relay.QL`
      query MainQuery{
        store {
          ${ Component.getFragment('store') }
        }
      }
    `,
  };
  static routeName = 'AppHomeRoute';
}
