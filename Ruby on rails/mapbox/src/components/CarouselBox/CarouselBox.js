import React, { Component } from 'react';
import Carousel from 'react-bootstrap/Carousel';
import footballImg from '../../assets/slider/0001.jpg';
import dreamImg from '../../assets/slider/02.jpg';
import companyImg from '../../assets/slider/003.jpg';
import schoolbusImg from '../../assets/slider/slider-3.jpg';
import './slider.scss';



export default class CarouselBox extends Component {
  render () {
    return (
      <Carousel>

        <Carousel.Item>
          <img 
            className="d-block w-100 size"
            src={ schoolbusImg }
            alt="School Bus"
          />
          {/* <img 
            className="d-block w-50 size"
            src={ companyImg }
            alt="School Bus"
          /> */}
        
        <Carousel.Caption>
          <p className="text-1">Новини ваших шкіл</p><br/>
          <p className="text-2">Електронні заяви на вступ в нову школу</p>
        </Carousel.Caption>
        </Carousel.Item>

        <Carousel.Item>
          <img 
            className="d-block w-100 size"
            src={ footballImg }
            alt="Футбол"
          />
       
        <Carousel.Caption>
          <p>Школи з різними ухилами і секціями</p>
        </Carousel.Caption>
        </Carousel.Item>
        
        <Carousel.Item>
          <img 
            className="d-block w-100 size"
            src={ companyImg }
            alt="Свята"
          />
        
        <Carousel.Caption>
          <p>Свята</p>
        </Carousel.Caption>
        </Carousel.Item>
        
        <Carousel.Item>
          <img 
            className="d-block w-100 size"
            src={ dreamImg }
            alt="dream"
          />
        
        <Carousel.Caption>
          <p>Участь і перемоги у конкурсах, олімпіадах</p>
        </Carousel.Caption>
        </Carousel.Item>
      
      </Carousel>
    )
  }
}


// <Carousel>
//   <Carousel.Item>
//     <img
//       className="d-block w-100"
//       src={ schoolbusImg }
//       alt="First slide"
//     />
//     <Carousel.Caption>
//       <h3>First slide label</h3>
//       <p>Nulla vitae elit libero, a pharetra augue mollis interdum.</p>
//     </Carousel.Caption>
//   </Carousel.Item>
//   <Carousel.Item>
//     <img
//       className="d-block w-100"
//       src={ footballImg }
//       alt="Third slide"
//     />

//     <Carousel.Caption>
//       <h3>Second slide label</h3>
//       <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
//     </Carousel.Caption>
//   </Carousel.Item>
//   <Carousel.Item>
//     <img
//       className="d-block w-100"
//       src="holder.js/800x400?text=Third slide&bg=20232a"
//       alt="Third slide"
//     />

//     <Carousel.Caption>
//       <h3>Third slide label</h3>
//       <p>Praesent commodo cursus magna, vel scelerisque nisl consectetur.</p>
//     </Carousel.Caption>
//   </Carousel.Item>
// </Carousel>

