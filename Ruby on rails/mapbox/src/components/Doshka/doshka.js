import React from 'react';
import "./doshka.scss";


const Doshka = () => {
  return (
    <div>
      <header>
        Дошка пошани
    </header>
      <div class="container">
        <div class="block">
          <div class="header-block">
          Юні спортсмени  завоювали 37 медалей на відкритій першості з плавання серед дітей з інвалідністю
      </div>
          <div class="main-block">
            <img src={require('../../assets/doshka/02.jpg')} alt="wasd"></img>
            <div class="text-block">
            За результатами відкритої першості юні луганчани завоювали 37 медалей: 15 золотих, 14 срібних і 8 бронзових.
            Тренують луганських плавців Олексій Ганусенко і Надія Можаєва.
      </div>
          </div>
        </div>

        <div class="block margin-top">
          <div class="header-block">
            Перші місця учнів з Сєвєродонецька
      </div>
          <div class="main-block">
            <img src={require('../../assets/doshka/01.jpg')} alt="wasd"></img>
            <div class="text-block">
              Діти з Сєвєродонецької школи №20 займають перші місця з танців
      </div>
          </div>
        </div>

        <div class="block margin-top">
          <div class="header-block">
            Юні танцюристи з Луганська завоювали перші місця на турнірі з бальних танців в Москві
      </div>
          <div class="main-block">
          <img src={require('../../assets/doshka/03.jpg')} alt="wasd"></img>
            <div class="text-block">
              У класифікаційних змаганнях юна пара Олександра Сафонова і Анастасії Новікової завоювала перше місце відразу в двох категоріях - діти 8-9 років (N3) і діти 8-9 років (N4).
              У ЛУВО відзначили, що турнір «Осіння Москва» є значущою подією в культурному танцювального життя столиці Росії і знаходить з кожним роком все більших масштабів.
      </div>
          </div>
        </div>

      </div>

    </div>

  );
}

export default Doshka;