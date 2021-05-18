puts 'cleaning database...'
Product.destroy_all

puts 'creating products...'
products_attributes = [
  {
    title: 'Marmite en fonte émaillée Sitram 5L',
    description: "Ultra résistante cocotte fabriquée en fonte d'acier émaillé fondue d'un seul bloc Cocotte compatible toutes sources de chaleur y compris induction four sans limite de température Idéale pour préparer de délicieux plats mijotés à base de viande de poisson ou de légumes.",
    remote_image_url: 'https://images-na.ssl-images-amazon.com/images/I/81H57WgSkCL._AC_SL1500_.jpg',
    url: 'https://amzn.to/3w3ryrU',
    provider: 'Amazon',
    country: 'FR'
  },
  {
    title: 'Fouet danois',
    description: 'Ce fouet danois est plus efficace et plus rapide que les fouets traditionnels. Adaptée pour mélanger les pâtes épaisses comme par exemple les pâtes à pain, pâtes à gâteaux et même des purées.',
    remote_image_url: 'https://images-na.ssl-images-amazon.com/images/I/71--8um8JML._AC_SL1500_.jpg',
    url: 'https://amzn.to/2RZF0OL',
    provider: 'Amazon',
    country: 'FR'
  },
  {
    title: 'Marmite en fonte émaillée Lodge 6L',
    description: "Une combinaison parfaite de forme et de fonction qui ne s'arrête pas, le Lodge Dutch Oven est un classique en fonte émaillée idéal pour préparer et servir des repas mémorables.",
    remote_image_url: 'https://images-na.ssl-images-amazon.com/images/I/71tN09vv0jL._AC_SL1500_.jpg',
    url: 'https://amzn.to/3bp1GP0',
    provider: 'Amazon',
    country: 'US'
  },
  {
    title: 'Fouet danois',
    description: 'Ce fouet danois est plus efficace et plus rapide que les fouets traditionnels. Adaptée pour mélanger les pâtes épaisses comme par exemple les pâtes à pain, pâtes à gâteaux et même des purées.',
    remote_image_url: 'https://images-na.ssl-images-amazon.com/images/I/71--8um8JML._AC_SL1500_.jpg',
    url: 'https://amzn.to/3frjydf',
    provider: 'Amazon',
    country: 'US'
  }
]

Product.create!(products_attributes)
puts 'done.'
