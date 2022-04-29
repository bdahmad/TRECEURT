import React, { Component } from 'react';
import { BrowserRouter as Router} from 'react-router-dom';

import Header from './components/menu/Header';
import Routes from './components/menu/Routes';
import menu from './constants/menu';
import web3 from './constants/web3';
import contracts from './constants/contracts';

export default class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      routes: menu.routes,
      loader: true
    }
  }

  componentDidCatch(error, info){
    console.log(error, info);
  }

  componentWillMount() {
    Promise.all([
      web3.init(),
      contracts.init()
      ]).then(()=>{
        this.setState({loader: false});
      })
      .catch(()=>{
      });
  }
  render() {
    return (
      <Router>
        <div className="body">
            <Header/>
            <Routes menu={this.state.routes}/>
        </div>
      </Router>
    );
  }
}
