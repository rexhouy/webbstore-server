# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Group.create({name: "拾惠社"})
Channel.create([ {name: "订桌订餐", group_id: 1, image: "http://uploads.test.tenhs.com/images/20160203/8db6d343-8e29-4104-a8e5-7c26b04f0d98.jpg", url: "/reservations/new"},
                 {name: "外卖点餐", group_id: 1, image: "http://uploads.test.tenhs.com/images/20151127/fa3d032d-16fa-4a6f-acdc-7cb2275532c3.jpg", url: "/takeout_menu"},
                 {name: "店内点餐", group_id: 1, image: "http://uploads.test.tenhs.com/images/20160203/f9376a35-a683-4220-a702-04ea181698fe.jpg", url: "/menu/1"}])
