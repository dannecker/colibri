FactoryGirl.define do
  factory :stock_movement, class: Colibri::StockMovement do
    quantity 1
    action 'sold'
    stock_item
  end

  trait :received do
    action 'received'
  end
end
