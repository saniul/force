{ extend } = require 'underscore'
{ PARAMS, AUCTION, CURRENT_USER } = require('sharify').data
ArtworkAuctionView = require './view.coffee'
Sticky = require '../../../../components/sticky/index.coffee'
metaphysics = require '../../../../lib/metaphysics.coffee'
openConfirmBidModal = require './components/confirm_bid/index.coffee'
{ history } = require 'backbone'

query = """
  query artwork($id: String!, $sale_id: String!) {
    me {
      bidder_status(artwork_id: $id, sale_id: $sale_id) {
        is_highest_bidder
      }
    }
    artwork(id: $id) {
      ... auction
    }
  }
  #{require './query.coffee'}
"""

module.exports = ->
  $el = $('.js-artwork-auction-container')

  return unless $el.length

  view = new ArtworkAuctionView
    el: $el.find '.js-artwork-auction'

  sticky = new Sticky
  sticky.add $el

  metaphysics
    query: query
    variables: id: AUCTION.artwork_id, sale_id: AUCTION.id
    req: user: CURRENT_USER

  .then (data) ->
    view.data = extend data, user: CURRENT_USER?
    view.render()

    if PARAMS.action is 'confirm-bid' and CURRENT_USER.paddle_number?
      openConfirmBidModal CURRENT_USER.paddle_number
        .view.once 'closed', ->
          history.start pushState: true
          history.navigate data.artwork.href
