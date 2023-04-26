# 需要测试的主流程：
## login
## get store / products
- 获取用户的default store_id
- 如果没有，设置一个并重新获取
- 获取这个store的product list，验证正确性。
## Address
- 检查现在address列表
- 添加一个shipping address，检查目前address列表增加一个item，同时default shipping address变成刚刚添加的shipping address了。
- 添加一个biling address，统一检查address和default billing address
## Payment method
- 确认currentPaymentMethod为空。
- 从stripe创建一个paymentMethod，并设置其为current payment method；设置失败，add a payment method，并设置为current payment method，验证一下。

## checkout
- 放两个商品到cart里面去
- 验证他们的价格/税/shipping都是正确的。
- 用current payment method checkout.
- 验证我们可以正确的看到order。（not implement yet)

- 再放两个商品到cart里去
- 再次验证价格 / 税 / shipping
- 按上面流程创建一个新的payment method checkout
- 并验证我们可以看到正确的order

- 获取order，我们应该可以看到刚才的两个order.


## Order
### Refund