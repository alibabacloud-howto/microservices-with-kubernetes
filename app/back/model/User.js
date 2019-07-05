'use strict'

const UserPurchase = require('./UserPurchase.js').default;

exports.default = class User {
  constructor(id, name, purchaseList) {
    this.id = id || 999999;
    this.name = name || 'default';
    this.purchaseList = purchaseList || [];
  }

  setPurchaseList(userPurchaseList) {
    this.purchaseList = userPurchaseList.map((params) => new UserPurchase(params));
  }
}
