# frozen_string_literal: true

class AddRedirects03022020 < ActiveRecord::Migration
  def change
    urls = [{ url: "/meditsinskaya-kosmetologiya-bazovaya-podgotovka", new_url: "/kursy-kosmetologii/meditsinskaya-kosmetologiya-bazovaya-podgotovka" },
            { url: "/esteticheskaya-kosmetologiya-bazovaya-podgotovka", new_url: "/kursy-kosmetologii/esteticheskaya-kosmetologiya-bazovaya-podgotovka" },
            { url: "/meditsinskaya-kosmetologiya-povyshenie-kvalifikatsii", new_url: "/kursy-kosmetologii/meditsinskaya-kosmetologiya-povyshenie-kvalifikatsii" },
            { url: "/esteticheskaya-kosmetologiya-povyshenie-kvalifikatsii", new_url: "/kursy-kosmetologii/esteticheskaya-kosmetologiya-povyshenie-kvalifikatsii" },
            { url: "/kosmetologiya-in-ektsionnaya-kosmetologiya", new_url: "/kursy-kosmetologii/kosmetologiya-in-ektsionnaya-kosmetologiya" },
            { url: "/sertifikatsiya", new_url: "/kursy-kosmetologii/sertifikatsiya" },
            { url: "/kosmetologiya-nmo-minzdrava", new_url: "/kursy-kosmetologii/kosmetologiya-nmo-minzdrava" },
            { url: "/meditsinskiy-massazh", new_url: "/kursy-massazha/meditsinskiy-massazh" },
            { url: "/spa-massazh", new_url: "/kursy-massazha/spa-massazh" },
            { url: "/povyshenie-kvalifikatsii", new_url: "/kursy-massazha/povyshenie-kvalifikatsii" },
            { url: "/permanentniy-makiyazh", new_url: "/kursy-makiyazha/permanentniy-makiyazh" },
            { url: "/brovistika", new_url: "/kursy-makiyazha/brovistika" },
            { url: "/grim", new_url: "/kursy-makiyazha/grim" },
            { url: "/rukovoditelyam", new_url: "/kursy-management/rukovoditelyam" },
            { url: "/vladeltsam-biznesa", new_url: "/kursy-management/vladeltsam-biznesa" },
            { url: "/administratoram-i-menedzheram", new_url: "/kursy-management/administratoram-i-menedzheram" },
            { url: "/kosmetologam-kotorye-rabotayut-na-sebya", new_url: "/kursy-management/kosmetologam-kotorye-rabotayut-na-sebya" },
            { url: "/besplatnye-kursy-50-besplatnye-kursy-50", new_url: "/besplatnye-kursy-50/besplatnye-kursy-50-besplatnye-kursy-50" },
            { url: "/online-kursy-online-kursy", new_url: "/online-kursy/online-kursy-online-kursy" }]

    urls.each do |u|
      OldUrl.create(url: u[:url], new_url: u[:new_url])
    end
  end
end
