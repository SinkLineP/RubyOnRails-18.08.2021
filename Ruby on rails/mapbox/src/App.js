import React from 'react';
import './App.scss';
import Mapbox from './components/Mapbox/mapbox';
import Navbar from './components/Navbar/Navbar';
import Footer from './components/Footer/footer';
import Slider from './components/Slider/slider';
import Doshka from './components/Doshka/doshka';


import CarouselBox from './components/CarouselBox/CarouselBox';

function App() {


  const factsSlides = [

	
		{
			id: '1333',
			imgUrl: require("./assets/slider/slider-02.jpg"),
			desc: "Свята"
		},
		{
			id: '1335',
			imgUrl: require("./assets/slider/slider-04.jpg"),
			desc: "Вихідні, канікули, карантин в ваших школах"
		},
		{
			id: '1334',
			imgUrl: require("./assets/slider/slider-03.jpg"),
			desc: "Новини ваших шкіл"
		},
		{
			id: '1332',
			imgUrl: require("./assets/slider/slider-01.jpg"),
			desc: ""
		},
		{
			id: '1336',
			imgUrl: require("./assets/slider/slider-05.jpg"),
			desc: "Школи з різними ухилами і секціями"
		}
	];

  return (
    <>
      <div className="App">
        <Navbar/>
		<div className="slides-margin">
        <Slider slides={factsSlides}/>
		</div>
        <Doshka/>
		<Mapbox/>
        <Footer/>
      </div>
    </>
  );
}

export default App;
