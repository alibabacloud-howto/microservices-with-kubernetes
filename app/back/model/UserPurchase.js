'use strict'

exports.default = class UserPurchase {
  constructor(params) {
    this.id = params.id;
    this.userId = params.userId;
    this.item = params.item;
    this.place = params.place;
  }
}
