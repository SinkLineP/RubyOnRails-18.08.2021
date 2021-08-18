import React, { useState } from 'react';
import Nav from "../Navbar/navbar";
import "./header.scss";

const Header = ({ title, logos, links }) => {

    // const = logos
    const handleScroll = () => {
        if (window.scrollY > 200) {
            setBtnPosition(true);
        }
        else {
            setBtnPosition(false);
        }
    };

    return (
        <section className="">
            <div className="">
                <div className="">
                    <div className="">
                        {logosImages}
                    </div>
                    
                </div>
            </div>
        </section>
    );
};

export default Header;