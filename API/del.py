class Item (Resource) :
    @jwt_required()
    def get(self, name):
        for item in items:
            if item['name'] == name:
                return item
        return {'item': None}, 404

    def post(self, name):
        if next(filter(lambda x: x['name'] == name, items), None):
            return {'message': "An items with name '{}' already exists.".format(name)}, 400
        data= request.get_json()
        item = {'name': name, 'price': data['price']}
        items.append(item)
        return item, 201

    def delete(self, name):

      #  global items
       # items= list(filter(lambda x: x['name'] != name, items))
        #return {'message': 'Item deleted'}

        temp=[]
        check=0
        global items
        for i in items:
            if i['name'] != name:
                temp.append(i)
            else:
                check=1
                break
        if check == 0:
            return {'message': 'Item Not Found'}
        else:
            items=temp
            return {'message': 'Item deleted'}

    def put(self, name):
        data= request.get_json()
        item= next(filter(lambda x: x["name"] == name, items), None)
        if item is None:
            item = {'name': name, 'price': data['price']}
            items.append(item)
        else:
            item.update(data)
        return item




class ItemList(Resource):
    @jwt_required()
    def get(self):
        return{'items': items}

    items = []

    api.add_resource(Item, '/item/<string:name>')
    api.add_resource(ItemList, '/items')