class TransitionerClass
  constructor: (@defaultVelocityAnimation) ->
    @transitions = []
  
  transition: (obj) ->
    unless obj?.fromRoute?
      console.log 'ERROR: transition object must contain a fromRoute'
      return
    unless obj?.toRoute?
      console.log 'ERROR: transition object must contain a toRoute'
      return
    unless obj?.velocityAnimaton?
      console.log 'ERROR: transition object must contain a velocityAnimaton'
      return
    unless obj?.velocityAnimaton?.in?
      console.log 'ERROR: transition object must contain a velocityAnimaton.in'
      return
    unless obj?.velocityAnimaton?.out?
      console.log 'ERROR: transition object must contain a velocityAnimaton.out'
      return
    @transitions.push obj

  getAnimation: (fromRoute, toRoute) ->
    transitionObj = _.find @transitions, (transition) ->
      transition.fromRoute is fromRoute and transition.toRoute is toRoute

    if transitionObj
      return transitionObj.velocityAnimaton
    else if @defaultVelocityAnimation
      return defaultVelocityAnimation
    else
      return {
        in: (node, next) ->
          $(node).insertBefore(next)
        out: (node) ->
          $(node).remove()
      }
    if transitionObj?.animationName and transitionObj?.animationName of @animations
      return @animations[transitionObj.animationName](transitionObj.duration, transitionObj.easing)
    else
      return @animations[@default]()


# velocityAnimation is:
# {
#   in: insertElement function or velocity uipack string or velocity animation arguments
#   out: removeElement function or velocity uipack string or velocity animation arguments
# }


Transitioner = new TransitionerClass()

# Make unique transitioner divs.
counter = () ->
  count = 0
  return () -> count++

uniqueIdMaker = counter()

Template.transitioner.created = ->
  @id = uniqueIdMaker()

Template.transitioner.helpers
  id: () -> Template.instance().id


fromRoute = null
toRoute = null

Meteor.startup ->
  Tracker.autorun ->
    fromRoute = toRoute
    toRoute = Router.current()?.route.getName()

Template.transitioner.rendered = ->

  @find("#transitioner-"+@id)?._uihooks =
    insertElement: (node, next) ->
      animation = Transitioner.getAnimation(fromRoute, toRoute)
      if _.isFunction animation?.in 
        animation.in.apply this, [node, next]
      else if _.isString animation?.in
        $(node).insertBefore(next)
          .velocity animation.in
      else if _.isArray animation?.in
        $node = $(node)
        $node.insertBefore(next)
          .velocity.apply($node, animation.in)
      else
        console.log "ERROR: animation.in not found!!"
        $(node).insertBefore(next)

    removeElement: (node) ->
      animation = Transitioner.getAnimation(fromRoute, toRoute)
      if _.isFunction animation?.out 
        animation.out.apply this, [node]
      else if _.isString animation?.out
        $node = $(node)
        $node.velocity animation.out, 
          complete: -> $node.remove()
      else if _.isArray animation?.out
        $node = $(node)
        $node.velocity.apply($node, animation.out)
          .velocity {opacity: 0}, 
            duration:0
            queue: true
            complete: -> $node.remove()
      else
        console.log "ERROR: animation.out not found!!"
        $(node).remove()