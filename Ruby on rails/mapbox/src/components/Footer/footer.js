import React from 'react';
import "./footer.scss";

const Footer = ({}) => {
  // const line = [
      
  // ];


  return (
    <div>
      <div classNane="line"></div>
      <footer className="footer">
       
      <div className="main-footer">


        <table>
          <tr>
            <td>
              <a href="#">
                Text
            </a>

            </td>
            <td>
              <a href="#">
                Text
            </a>
            </td>
            <td>
              <a href="#">
                Text
            </a>
            </td>
          </tr>

          <tr>
            <td>
              <a href="#">
                Text
            </a>
            </td>
            <td>
              <a href="#">
                Text
            </a>
            </td>
            <td>
              <a href="#">
                Text
            </a>
            </td>
          </tr>

          <tr>
            <td>
              <a href="#">
                Text
            </a>
            </td>
            <td>
              <a href="#">
                Text
            </a>
            </td>
            <td>
              <a href="#">
                Text
            </a>
            </td>
          </tr>

          <tr>
            <td>
              <a href="#">
                Text
            </a>
            </td>
            <td>
              <a href="#">
                Text
            </a>
            </td>
            <td>
              <a href="#">
                Text
            </a>
            </td>
          </tr>
        </table>
        
 
        <div className="follow-us">
          слідкуйте за нами
        <div className="social-media">
          <a href="#"><i className="fab fa-facebook fa-2x"></i></a>
          <a href="#"><i className="fab fa-instagram fa-2x"></i></a>
          <a href="#"><i className="fab fa-twitter fa-2x"></i></a>
        </div>
        <br/><br/>
        <div> 
          
          Сайт був розроблений Командою <span className="red">МАРС</span> (майстер Революційних Систем)<br/>
В яку входять Попов Артем, Попова Карина, <br/>Наумов Артем, Бабкін Андрій, Мінаков Данило
        </div>
        <br/><br/>
            <a href="#"> <img src="images/mars-logo.png" className="main-links"   /> </a>
        </div>
      </div>
          <div className="main-footer">
            <div className="number">
              Якщо Вам потрібна допомога з публічним файлом, звертайтесь за номером<br/><br/> 
            <pre> +38(xxx)xxx-xx-xx        +38(xxx)xxx-xx-xx        +38(xxx)xxx-xx-xx        +38(xxx)xxx-xx-xx        +38(xxx)xxx-xx-xx </pre> 
            </div>
          </div>
      
        <hr />
          <div className="main-footer-footer">
            <img src="images/UNESCO_Logo.png" />
              <div >Copyright © 2020 Всі права захищені</div>
              <img src="images/mon.png" />
          </div>

      
      </footer>
    </div>
    );


};

export default Footer;