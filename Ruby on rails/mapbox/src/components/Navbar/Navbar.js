import React, { Component } from 'react';
import { MenuItems } from "./MenuItems";
// import Navbar from 'react-bootstrap/Navbar'
// import { Button } from "Button";
import "./Navbar.scss"

class Navbar extends Component {
    state = { clicked: false }

    handleClick = () => {
        this.setState({ clicked: !this.state.clicked })
    }

    render() {
        return (
            <nav className="NavbarItems">
                <img src="../assets/navbar/mars.png"></img><h1 className="navbar-logo contr-home">School <span className="mars">MARS</span></h1>
                <div className="menu-icon" onClick={this.handleClick}>
                    <i className={this.state.clicked ? 'fas fa-times' : 'fas fa-bars'}></i>
                </div>
                <ul className={this.state.clicked ? 'nav-menu active' : 'nav-menu'}>
                    {MenuItems.map((item, index) => {
                        return (
                            <li key={index} className="contr-button">
                                <a className={item.cName} href={item.url}>
                                    {item.title}
                                </a>
                            </li>
                        )
                    })}
                </ul>
                {/* <Button>Sign Up</Button> */}
            </nav>
        )
    }
}

export default Navbar