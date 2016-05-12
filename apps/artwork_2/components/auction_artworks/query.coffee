module.exports = """
  fragment auction_artworks on Artwork {
    sale {
      name
      href
      artworks(all: true, size: 50) {
        ... auction_artwork_brick
      }
    }
  }

  #{require '../../../../components/auction_artwork_brick/query.coffee'}
"""
