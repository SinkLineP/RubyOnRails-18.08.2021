class AddCourseLinks < ActiveRecord::Migration
  def up
    text = <<-DOC
    http://www.sikorsky.academy/admin/courses/80/edit

http://cosmeticru.com/courses/new-narashhivanie-i-vosstanovlenie-brovey/
http://cosmeticru.com/courses/new-korrektsiya-laminirovanie-brovey-i-resnits/
http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/shugaring/


http://www.sikorsky.academy/admin/courses/38/edit

http://cosmeticru.com/courses/shugaring/
http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/new-master-po-oformleniyu-brovey-i-resnits-polnyiy-kurs/


http://www.sikorsky.academy/admin/courses/41/edit

http://cosmeticru.com/courses/sekonom-1900r-botulotoksin-konturnaya-plastika/
http://cosmeticru.com/courses/new-skleroterapiya/
http://cosmeticru.com/courses/trihologiya/


http://www.sikorsky.academy/admin/courses/46/edit

http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/new-master-po-oformleniyu-brovey-i-resnits-polnyiy-kurs/
http://cosmeticru.com/courses/shugaring/
http://cosmeticru.com/courses/biodepilyatsiya-goryachim-voskom/


http://www.sikorsky.academy/admin/courses/35/edit

http://cosmeticru.com/courses/kosmetika-i-kosmetsevtika/
http://cosmeticru.com/courses/fito-i-aromaterapiya-dietoterapiya-v-kosmetologii/
http://cosmeticru.com/courses/osnovyi-zakonodatelstva-v-industrii-krasotyi/



http://www.sikorsky.academy/admin/courses/31/edit

http://cosmeticru.com/courses/estestvennaya-krasota-kak-uhazhivat-za-soboy-s-pomoshhyu-efirnyih-masel-i-lekarstvennyih-rasteniy/
http://cosmeticru.com/courses/iz-chego-na-samom-dele-sostoit-kosmetika/
http://cosmeticru.com/courses/new-kosmetik-estetist-dlya-vseh/


http://www.sikorsky.academy/admin/courses/32/edit

http://cosmeticru.com/courses/dietoterapiya-v-kosmetologii-kak-pitatsya-chtobyi-byit-krasivoy/
http://cosmeticru.com/courses/iz-chego-na-samom-dele-sostoit-kosmetika/
http://cosmeticru.com/courses/new-kosmetik-estetist-dlya-vseh/


http://www.sikorsky.academy/admin/courses/30/edit

http://cosmeticru.com/courses/estestvennaya-krasota-kak-uhazhivat-za-soboy-s-pomoshhyu-efirnyih-masel-i-lekarstvennyih-rasteniy/
http://cosmeticru.com/courses/dietoterapiya-v-kosmetologii-kak-pitatsya-chtobyi-byit-krasivoy/
http://cosmeticru.com/courses/new-kosmetik-estetist-dlya-vseh/

http://www.sikorsky.academy/admin/courses/82/edit

http://cosmeticru.com/courses/mezoniti/
http://cosmeticru.com/courses/trihologiya/
http://cosmeticru.com/courses/new-skleroterapiya/
http://cosmeticru.com/courses/sertifikatsiya-288-chasov-distantsionnyiy-kurs/
http://cosmeticru.com/courses/sertifikatsiya-576-chasov-distantsionnyiy-kurs/
http://www.sikorsky.academy/admin/courses/43/edit

http://cosmeticru.com/courses/master-klass-po-rabote-s-kanyulyami/
http://cosmeticru.com/courses/mezoniti/
http://cosmeticru.com/courses/botulotoksin-tipa-a/
http://cosmeticru.com/courses/spetspredlozhenie-mezoterapiya-biorevitalizatsiya-sekonom-2900-rub/


http://www.sikorsky.academy/admin/courses/17/edit

http://cosmeticru.com/courses/new-master-po-oformleniyu-brovey-i-resnits-polnyiy-kurs/
http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/shugaring/
http://cosmeticru.com/courses/new-sekonom-8800-vse-inektsii-mezoniti-i-kanyuli/


http://www.sikorsky.academy/admin/courses/33/edit

http://cosmeticru.com/courses/fito-i-aromaterapiya-dietoterapiya-v-kosmetologii/
http://cosmeticru.com/courses/dermatologiya-dlya-kosmetologov/
http://cosmeticru.com/courses/osnovyi-zakonodatelstva-v-industrii-krasotyi/
http://cosmeticru.com/courses/new-kosmetik-estetist-dlya-vseh/

http://www.sikorsky.academy/admin/courses/58/edit

http://cosmeticru.com/courses/mezoniti/
http://cosmeticru.com/courses/master-klass-po-rabote-s-kanyulyami/
http://cosmeticru.com/courses/trihologiya/


http://www.sikorsky.academy/admin/courses/68/edit

http://cosmeticru.com/courses/new-sekonom-8800-vse-inektsii-mezoniti-i-kanyuli/
http://cosmeticru.com/courses/new-skleroterapiya/
http://cosmeticru.com/courses/trihologiya/
http://cosmeticru.com/courses/apparatnaya-kosmetologiya/
http://cosmeticru.com/courses/new-himicheskie-pilingi/
http://cosmeticru.com/courses/cadaver-class-light-dlya-vrachey-kosmetologov/


http://www.sikorsky.academy/admin/courses/69/edit

http://cosmeticru.com/courses/new-sekonom-8800-vse-inektsii-mezoniti-i-kanyuli/
http://cosmeticru.com/courses/new-skleroterapiya/
http://cosmeticru.com/courses/trihologiya/
http://cosmeticru.com/courses/apparatnaya-kosmetologiya/
http://cosmeticru.com/courses/new-himicheskie-pilingi/
http://cosmeticru.com/courses/cadaver-class-light-dlya-vrachey-kosmetologov/


http://www.sikorsky.academy/admin/courses/90/edit

http://cosmeticru.com/courses/new-sekonom-8800-vse-inektsii-mezoniti-i-kanyuli/
http://cosmeticru.com/courses/new-skleroterapiya/
http://cosmeticru.com/courses/trihologiya/
http://cosmeticru.com/courses/apparatnaya-kosmetologiya/
http://cosmeticru.com/courses/new-himicheskie-pilingi/
http://cosmeticru.com/courses/cadaver-class-light-dlya-vrachey-kosmetologov/


http://www.sikorsky.academy/admin/courses/81/edit

http://cosmeticru.com/courses/new-narashhivanie-i-vosstanovlenie-brovey/
http://cosmeticru.com/courses/arhitektura-brovey/
http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/shugaring/


http://www.sikorsky.academy/admin/courses/88/edit

http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/shugaring/
http://cosmeticru.com/courses/hiroplasticheskiy-massazh-litsa/


http://www.sikorsky.academy/admin/courses/74/edit

http://cosmeticru.com/courses/new-master-po-oformleniyu-brovey-i-resnits-polnyiy-kurs/
http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/new-kosmetik-estetist-dlya-vseh/
http://cosmeticru.com/courses/shugaring/


http://www.sikorsky.academy/admin/courses/47/edit

http://cosmeticru.com/courses/new-master-po-oformleniyu-brovey-i-resnits-polnyiy-kurs/
http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/new-kosmetik-estetist-dlya-vseh/
http://cosmeticru.com/courses/shugaring/


http://www.sikorsky.academy/admin/courses/65/edit

http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/hiroplasticheskiy-massazh-litsa/
http://cosmeticru.com/courses/apparatnaya-kosmetologiya/


http://www.sikorsky.academy/admin/courses/55/edit

http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/new-narashhivanie-i-vosstanovlenie-brovey/
http://cosmeticru.com/courses/new-kosmetik-estetist-dlya-vseh/
http://cosmeticru.com/courses/shugaring/


http://www.sikorsky.academy/admin/courses/66/edit

http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/hiroplasticheskiy-massazh-litsa/
http://cosmeticru.com/courses/apparatnaya-kosmetologiya/
http://cosmeticru.com/courses/massazh-lomi-lomi-telo-i-litso/
http://cosmeticru.com/courses/ekzamen-na-mezhdunarodnyiy-diplom-itec-v-oblasti-spa-i-massazha/


http://www.sikorsky.academy/admin/courses/77/edit

 http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/hiroplasticheskiy-massazh-litsa/
http://cosmeticru.com/courses/apparatnaya-kosmetologiya/
http://cosmeticru.com/courses/massazh-lomi-lomi-telo-i-litso/
http://cosmeticru.com/courses/ekzamen-na-mezhdunarodnyiy-diplom-itec-v-oblasti-spa-i-massazha/


http://www.sikorsky.academy/admin/courses/83/edit

http://cosmeticru.com/courses/sertifikatsiya-288-chasov-distantsionnyiy-kurs/
http://cosmeticru.com/courses/sertifikatsiya-576-chasov-distantsionnyiy-kurs/
http://cosmeticru.com/courses/master-klass-po-rabote-s-kanyulyami/
http://cosmeticru.com/courses/new-skleroterapiya/


http://www.sikorsky.academy/admin/courses/40/edit

http://cosmeticru.com/courses/biorevitalizatsiya/
http://cosmeticru.com/courses/sekonom-1900r-botulotoksin-konturnaya-plastika/
http://cosmeticru.com/courses/trihologiya/
http://cosmeticru.com/courses/new-skleroterapiya/


http://www.sikorsky.academy/admin/courses/89/edit

http://cosmeticru.com/courses/new-master-po-oformleniyu-brovey-i-resnits-polnyiy-kurs/
http://cosmeticru.com/courses/new-makiyazh-i-pricheski-dlya-torzhestva/
http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/shugaring/
http://cosmeticru.com/courses/vizazhnoe-iskusstvo/


http://www.sikorsky.academy/admin/courses/50/edit

http://cosmeticru.com/courses/new-sekonom-8800-vse-inektsii-mezoniti-i-kanyuli/
http://cosmeticru.com/courses/trihologiya/
http://cosmeticru.com/courses/sertifikatsiya-576-chasov-distantsionnyiy-kurs/
http://cosmeticru.com/courses/sertifikatsiya-288-chasov-distantsionnyiy-kurs/


http://www.sikorsky.academy/admin/courses/29/edit

http://cosmeticru.com/courses/organizatsiya-zdravoohraneniya-i-obshhestvennoe-zdorove/
http://cosmeticru.com/courses/sertifikatsiya-288-chasov-distantsionnyiy-kurs/
http://cosmeticru.com/courses/sertifikatsiya-576-chasov-distantsionnyiy-kurs/
http://cosmeticru.com/courses/sertifikatsiya-144-chasa/


http://www.sikorsky.academy/admin/courses/87/edit

http://cosmeticru.com/courses/new-master-po-oformleniyu-brovey-i-resnits-polnyiy-kurs/
http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/new-kosmetik-estetist-dlya-vseh/
http://cosmeticru.com/courses/shugaring/


http://www.sikorsky.academy/admin/courses/53/edit

http://cosmeticru.com/courses/new-skleroterapiya/
http://cosmeticru.com/courses/new-sekonom-8800-vse-inektsii-mezoniti-i-kanyuli/
http://cosmeticru.com/courses/sertifikatsiya-288-chasov-distantsionnyiy-kurs/
http://cosmeticru.com/courses/sertifikatsiya-576-chasov-distantsionnyiy-kurs/

http://www.sikorsky.academy/admin/courses/49/edit

http://cosmeticru.com/courses/new-skleroterapiya/
http://cosmeticru.com/courses/new-sekonom-8800-vse-inektsii-mezoniti-i-kanyuli/
http://cosmeticru.com/courses/trihologiya/
http://cosmeticru.com/courses/plazmolifting/

http://www.sikorsky.academy/admin/courses/72/edit

http://cosmeticru.com/courses/new-master-po-oformleniyu-brovey-i-resnits-polnyiy-kurs/
http://cosmeticru.com/courses/new-kosmetik-estetist-dlya-vseh/
http://cosmeticru.com/courses/shugaring/
http://cosmeticru.com/courses/hiroplasticheskiy-massazh-litsa/

http://www.sikorsky.academy/admin/courses/73/edit

http://cosmeticru.com/courses/new-skleroterapiya/
http://cosmeticru.com/courses/trihologiya/
http://cosmeticru.com/courses/sertifikatsiya-576-chasov-distantsionnyiy-kurs/
http://cosmeticru.com/courses/new-sekonom-8800-vse-inektsii-mezoniti-i-kanyuli/


http://www.sikorsky.academy/admin/courses/42/edit

http://cosmeticru.com/courses/konturnaya-plastika/
http://cosmeticru.com/courses/spetspredlozhenie-mezoterapiya-biorevitalizatsiya-sekonom-2900-rub/
http://cosmeticru.com/courses/mezoniti/
http://cosmeticru.com/courses/master-klass-po-rabote-s-kanyulyami/

http://www.sikorsky.academy/admin/courses/19/edit

http://cosmeticru.com/courses/kosmetik-estetist-povyishenie-kvalifikatsii-dlya-vyipusknikov-instituta/
http://cosmeticru.com/courses/new-sekonom-8800-vse-inektsii-mezoniti-i-kanyuli/
http://cosmeticru.com/courses/trihologiya/
http://cosmeticru.com/courses/apparatnaya-kosmetologiya/
http://cosmeticru.com/courses/new-skleroterapiya/


http://www.sikorsky.academy/admin/courses/70/edit

http://cosmeticru.com/courses/new-sekonom-8800-vse-inektsii-mezoniti-i-kanyuli/
http://cosmeticru.com/courses/trihologiya/
http://cosmeticru.com/courses/new-himicheskie-pilingi/
http://cosmeticru.com/courses/inektsionnyie-metodyi-v-kosmetologii/

http://www.sikorsky.academy/admin/courses/71/edit

http://cosmeticru.com/courses/new-sekonom-8800-vse-inektsii-mezoniti-i-kanyuli/
http://cosmeticru.com/courses/trihologiya/
http://cosmeticru.com/courses/new-himicheskie-pilingi/
http://cosmeticru.com/courses/inektsionnyie-metodyi-v-kosmetologii/

http://www.sikorsky.academy/admin/courses/79/edit

http://cosmeticru.com/courses/new-sekonom-8800-vse-inektsii-mezoniti-i-kanyuli/
http://cosmeticru.com/courses/trihologiya/
http://cosmeticru.com/courses/apparatnaya-kosmetologiya/
http://cosmeticru.com/courses/sertifikatsiya-576-chasov-distantsionnyiy-kurs/

http://www.sikorsky.academy/admin/courses/48/edit

http://cosmeticru.com/courses/new-sekonom-8800-vse-inektsii-mezoniti-i-kanyuli/
http://cosmeticru.com/courses/trihologiya/
http://cosmeticru.com/courses/new-skleroterapiya/
http://cosmeticru.com/courses/plazmolifting/

http://www.sikorsky.academy/admin/courses/39/edit

http://cosmeticru.com/courses/sertifikatsiya-288-chasov-distantsionnyiy-kurs/
http://cosmeticru.com/courses/sertifikatsiya-576-chasov-distantsionnyiy-kurs/
http://cosmeticru.com/courses/mezoniti/
http://cosmeticru.com/courses/master-klass-po-rabote-s-kanyulyami/

http://www.sikorsky.academy/admin/courses/76/edit

http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/hiroplasticheskiy-massazh-litsa/
http://cosmeticru.com/courses/apparatnaya-kosmetologiya/

http://www.sikorsky.academy/admin/courses/85/edit

http://cosmeticru.com/courses/new-sekonom-8800-vse-inektsii-mezoniti-i-kanyuli/
http://cosmeticru.com/courses/spetspredlozhenie-mezoterapiya-biorevitalizatsiya-sekonom-2900-rub/
http://cosmeticru.com/courses/botulotoksin-tipa-a/
http://cosmeticru.com/courses/trihologiya/

http://www.sikorsky.academy/admin/courses/34/edit


http://cosmeticru.com/courses/dermatologiya-dlya-kosmetologov/
http://cosmeticru.com/courses/osnovyi-zakonodatelstva-v-industrii-krasotyi/
http://cosmeticru.com/courses/new-kosmetik-estetist-dlya-vseh/
http://cosmeticru.com/courses/kosmetika-i-kosmetsevtika/


http://www.sikorsky.academy/admin/courses/45/edit

http://cosmeticru.com/courses/new-sekonom-8800-vse-inektsii-mezoniti-i-kanyuli/
http://cosmeticru.com/courses/trihologiya/
http://cosmeticru.com/courses/sertifikatsiya-288-chasov-distantsionnyiy-kurs/
http://cosmeticru.com/courses/sertifikatsiya-576-chasov-distantsionnyiy-kurs/

http://www.sikorsky.academy/admin/courses/84/edit

http://cosmeticru.com/courses/new-master-po-oformleniyu-brovey-i-resnits-polnyiy-kurs/
http://cosmeticru.com/courses/new-makiyazh-i-pricheski-dlya-torzhestva/
http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/shugaring/

http://www.sikorsky.academy/admin/courses/75/edit

http://cosmeticru.com/courses/new-master-po-oformleniyu-brovey-i-resnits-polnyiy-kurs/
http://cosmeticru.com/courses/new-makiyazh-i-pricheski-dlya-torzhestva/
http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/new-kosmetik-estetist-dlya-vseh/

http://www.sikorsky.academy/admin/courses/21/edit


http://cosmeticru.com/courses/kosmetik-estetist-povyishenie-kvalifikatsii-dlya-vyipusknikov-instituta/
http://cosmeticru.com/courses/new-master-po-oformleniyu-brovey-i-resnits-polnyiy-kurs/
http://cosmeticru.com/courses/new-makiyazh-i-pricheski-dlya-torzhestva/
http://cosmeticru.com/courses/new-permanentnyiy-makiyazh/
http://cosmeticru.com/courses/new-kosmetik-estetist-dlya-vseh/
    DOC

    course_id = nil

    text.split("\s").each do |link|
      next if link.blank?

      if link.include?('http://www.sikorsky.academy/admin/courses/')
        course_id = link[/\d+/].to_i
      else
        next if Course.find_by(id: course_id).blank?
        CourseLink.create!(course_id: course_id, link: link)
      end
    end
  end

  def down
    CourseLink.destroy_all
  end
end
