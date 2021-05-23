puts 'cleaning database...'
Product.destroy_all

puts 'creating products...'
products_attributes = [
  {
    country: 'FR',
    description: "Ultra résistante cocotte fabriquée en fonte d'acier émaillé fondue d'un seul bloc Cocotte compatible toutes sources de chaleur y compris induction four sans limite de température Idéale pour préparer de délicieux plats mijotés à base de viande de poisson ou de légumes.",
    provider: 'Amazon',
    remote_image_url: 'https://images-na.ssl-images-amazon.com/images/I/81H57WgSkCL._AC_SL1500_.jpg',
    url: 'https://amzn.to/3w3ryrU',
    title: 'Marmite en fonte émaillée Sitram 5L',
  },
  {
    country: 'FR',
    description: 'Ce fouet danois est plus efficace et plus rapide que les fouets traditionnels. Adaptée pour mélanger les pâtes épaisses comme par exemple les pâtes à pain, pâtes à gâteaux et même des purées.',
    provider: 'Amazon',
    remote_image_url: 'https://images-na.ssl-images-amazon.com/images/I/71--8um8JML._AC_SL1500_.jpg',
    title: 'Fouet danois',
    url: 'https://amzn.to/2RZF0OL'
  },
  {
    country: 'FR',
    description: 'Rouleaux à pâtisserie en acier inoxydable avec tapis de cuisson en silicone, rouleaux pâtisserie antiadhésifs avec anneaux réglables pour cuisson fondant pâte.',
    provider: 'Amazon',
    remote_image_url: 'https://images-na.ssl-images-amazon.com/images/I/71JWK3UDi%2BL._AC_SL1500_.jpg,
    title: 'Rouleaux à Pâtisserie',
    url: 'https://amzn.to/3bMuOjF'
  },
  {
    country: 'US',
    description: "Une combinaison parfaite de forme et de fonction qui ne s'arrête pas, le Lodge Dutch Oven est un classique en fonte émaillée idéal pour préparer et servir des repas mémorables.",
    provider: 'Amazon',
    remote_image_url: 'https://images-na.ssl-images-amazon.com/images/I/71tN09vv0jL._AC_SL1500_.jpg',
    title: 'Marmite en fonte émaillée Lodge 6L',
    url: 'https://amzn.to/3bp1GP0'
  },
  {
    country: 'US',
    description: 'Ce fouet danois est plus efficace et plus rapide que les fouets traditionnels. Adaptée pour mélanger les pâtes épaisses comme par exemple les pâtes à pain, pâtes à gâteaux et même des purées.',
    provider: 'Amazon',
    remote_image_url: 'https://images-na.ssl-images-amazon.com/images/I/71--8um8JML._AC_SL1500_.jpg',
    title: 'Fouet danois',
    url: 'https://amzn.to/3frjydf'
  },
  {
    country: 'US',
    description: "Parfait pour une famille de 4 personnes",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/860f0048-f037-48ff-8141-d1d395a2baf8.jpg",
    title: "Marmite en fonte 4.75 L",
    url: "https://amzn.to/30sW9PC"
  },
  {
    country: 'US',
    description: "Parfait pour crêpes, pancakes, et pizzas",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/929c3fac-a566-43ca-87e8-f31437854251.jpg",
    title: "Poêle en fonte (type crêpière)",
    url: "https://amzn.to/2JuChpv"
  },
  {
    country: 'US',
    description: "Ce qui fait toute la différence...",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/c3c941a7-cf10-4f23-8e52-8791a031b659.jpg",
    title: "Pizza, plaque de cuisson",
    url: "https://amzn.to/32FIHt0"
  },
  {
    country: 'US',
    description: "Mason Jars 500 ml",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/509b8315-4cc4-4179-804c-31b7027af315.jpg",
    title: "Pots en verre avec couvercle",
    url: "https://amzn.to/30BWYpz"
  },
  {
    country: 'US',
    description: "5 casseroles en fonte, un investissement pour la vie",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/e7105597-6c81-4fae-b091-8506ee19691a.jpg",
    title: "Batterie de cuisine",
    url: "https://amzn.to/2NUwY5p"
  },
  {
    country: 'US',
    description: "Un poêle de 26 cm, un indispensable de la cuisine",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/32ccbdad-d7dd-46ce-9f99-312ce5945b7f.jpg",
    title: "Poêle en fonte",
    url: "https://amzn.to/2Ls242F"
  },
  {
    country: 'US',
    description: "Lodge Cast Iron Mini Cake Pan",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/43217a0a-481b-4593-b269-3381a25b3f6e.jpg",
    title: "Moule à biscuits et mini gâteaux",
    url: "https://amzn.to/2XJyqsP"
  },
  {
    country: 'FR',
    description: "Moule 22 cm en porcelaine de couleur jaune",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/f50d2b84-4626-4421-93c3-4377383ca020.jpg",
    title: "Moule à kougelhopf",
    url: "https://amzn.to/2XYIPVM"
  },
  {
    country: 'US',
    description: "Lodge LPGI3 plaque en fonte",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/a63f38b7-2196-4c8c-84de-a454c576508d.jpg",
    title: "Plaque de cuisson grill plancha",
    url: "https://amzn.to/2XOPVNa"
  },
  {
    country: 'US',
    description: "Acier Inoxydable 18/8",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/e146e093-4817-49a0-b39d-a50478993081.jpg",
    title: "Tasses et cuillères à mesurer",
    url: "https://amzn.to/2L6GZJG"
  },
  {
    country: 'US',
    description: "Marmite dite «cocotte minute» parfaite pour une famille de 4 personnes",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/f68619c0-cbb8-46c5-8ac4-a6b7a005ae42.jpg",
    title: "Autocuiseur 6 L",
    url: "https://amzn.to/32AoUed"
  },
  {
    country: 'US',
    description: "Corne Patisserie, Grattoir Racloir Patisserie, idéal pour travailler la pâte",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/8dffde44-060d-4101-9d7a-3a699b6af9b1.jpg",
    title: "Spatule Rigide",
    url: "https://amzn.to/2w8D1wu"
  },
  {
    country: 'US',
    description: "Dans l'ensemble, sa conception conviviale, son rendement élevé et ses bonnes performances font de ce broyeur un bon choix pour chaque ménage!",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/f4ab4985-7e32-4623-9a94-757b26f2acf1.jpg",
    title: "Moulin à grain en fonte",
    url: "https://amzn.to/33Gcx23"
  },
  {
    country: 'US',
    description: "Comprend 2 tubes à farcir la saucisse, accessoire pour hachoir à viande en métal pour kitchenAid",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/5858cc89-f7c2-4996-98cf-aa19e67780c2.jpg",
    title: "Hachoir  à viande durable",
    url: "https://amzn.to/3bbVnMg"
  },
  {
    country: 'US',
    description: "Poêle à deux poignées en fonte assaisonnée Lodge de 10,25 pouces est une nouvelle version d'un design classique. Parfait pour la cuisine de tous les jours, des crêpes du matin aux dîners au poulet rôti.",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/b947e134-10e7-4bd6-ac0d-a2d168a74b1c.jpg",
    title: "Lodge L10SKL Cast Iron Dual Handle Pan",
    url: "https://amzn.to/3aa37OD"
  },
  {
    country: 'US',
    description: "Obtenez les muffins chauds du four avec une belle croûte lorsque vous utilisez le moule à muffins en fonte. Faites l'expérience d'une distribution et d'une rétention de chaleur supérieures pour une cuisson uniforme et uniforme.",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/21653967-d7b3-4435-86bb-3d4bf06d4280.jpg",
    title: "Lodge L5P3 Mini Muffin/Cornbread Pan",
    url: "https://amzn.to/2xiDtsr"
  },
  {
    country: 'US',
    description: "La fonte est le moyen idéal pour la cuisson. La fonte chauffe uniformément et retient la chaleur pour des résultats de cuisson supérieurs. Ce moule à pain en fonte produit une croûte de pain brun doré à chaque cuisson. Aussi fantastique pour le pain de viande.",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/858cd3d7-8968-4f87-8167-829976eb7f96.jpg",
    title: "Lodge L4LP3 Lodge Loaf Pan",
    url: "https://amzn.to/2J9Acyh"
  },
  {
    country: 'US',
    description: "Le moule à gâteau cannelé de la série Lodge Legacy est un classique intemporel, c'est pourquoi il a été dévoilé une fois de plus. Avec la possibilité de transformer n'importe quel gâteau en une pièce unique, vous présenterez votre nouveau moule pour chaque célébration.",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/6130c930-b801-42fd-8e14-2da6cf17b416.jpg",
    title: "Lodge Fluted Cake Pan with Assist Handles",
    url: "https://amzn.to/2JgmcmN"
  },
  {
    country: 'US',
    description: "Idéal pour travailler les produits liquides",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/9aa71286-e2a8-44e4-a2e6-ab6445a21461.jpg",
    title: "Thermomètre de cuisson",
    url: "https://amzn.to/2NRArSq"
  },
  {
    country: 'US',
    description: "Préparez facilement vos gâteaux préférés et plusieurs lots de pâte à biscuits avec le bol à mélanger en acier inoxydable de 5 pintes avec une poignée confortable.",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/6f18a022-6c7b-4692-9db6-4b0cee08140e.jpg",
    title: "KitchenAid Artisan",
    url: "https://amzn.to/399tGlY"
  },
  {
    country: 'US',
    description: "Pointez, visez et mesurez pour obtenir les résultats dont vous avez besoin. Ce thermomètre peut être utilisé n'importe où. Mesurez des températures extrêmes allant de -50°C à 750°C sans jamais avoir besoin d'entrer en contact.",
    provider: 'Amazon',
    remote_image_url: "https://media.cuisinierrebelle.com/uploads/45e2738c-f5e7-4c29-97e6-774fb877308d.jpg",
    title: "Thermomètre Laser",
    url: "https://amzn.to/2WKDvUV"
  }
]

Product.create!(products_attributes)
puts 'done.'
