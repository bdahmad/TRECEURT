import React, { Component } from 'react';
import homeImg from './transfer+files.jpg';

export default class Home extends Component {
  constructor(props) {
    super(props);
  }
  render() {
    return (
      <div className='align-center' >
        <img className='responsive' src={homeImg} />
        <div className='responsivetexta' ><b>Document Exchange/Verification System</b></div>
        <div className='responsivetextb'>By TRECEURT</div>
      </div>
    );
  }
}

