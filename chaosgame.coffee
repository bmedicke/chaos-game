context             = canvas.getContext '2d'
canvas.width        = window.innerWidth
canvas.height       = window.innerHeight - 50

pointSize           = 0.5
pointsPerStep       = 1
divisor             = 1.6
edgeCount           = 3

maximumDivisor      = 2.5
minimumDivisor      = 0.3
divisorStep         = 0.1
timeout             = 50

context.fillStyle   = 'white'
context.strokeStyle = 'white'

vertices            = []

vertices.push  [canvas.width / 5, canvas.height]
vertices.push  [canvas.width / 5 * 4, canvas.height]
vertices.push  [canvas.width / 2, 0]
vertices.push  [0, canvas.height / 2.6]
vertices.push  [canvas.width, canvas.height / 2.6]
vertices.push  [canvas.width / 2, canvas.height / 1.8]

resetStartingPoint = ->
  [@newX, @newY]   = [vertices[0][0], vertices[0][1]]

drawPoint = (centerX, centerY, radius, fillPoint = on) ->
  context.beginPath()
  context.arc centerX, centerY, radius, 0, Math.PI*2, false
  context.closePath()
  if fillPoint then context.fill() else context.stroke()

drawFractalPoint = ->
  randomChoice  = Math.random()
  for vertex, i in vertices
    edgeCount = vertices.length if edgeCount > vertices.length
    maximumSpan = (i + 1) / edgeCount
    if randomChoice <= maximumSpan
      @newX = (@newX + vertex[0] * divisor) / (divisor + 1)
      @newY = (@newY + vertex[1] * divisor) / (divisor + 1)
      break

  drawPoint @newX, @newY, pointSize, true

renderFractal = ->
  @renderInterval = setInterval ->
    drawFractalPoint() for i in [0 ... pointsPerStep * edgeCount]
  , timeout

clearCanvas = ->
  context.clearRect 0, 0,
                    canvas.width,
                    canvas.height

@toggleRendering = ->
  if renderInterval?
    clearInterval renderInterval
    delete renderInterval
  else
    renderFractal()

@setSpeed = (speed = 1) -> pointsPerStep = speed

@setEdgeCount = (count = 3) ->
  edgeCount = count
  resetStartingPoint()
  clearCanvas()

@incrementDivisor = ->
  if divisor < maximumDivisor
    divisor += divisorStep
    resetStartingPoint()
    clearCanvas()

@decrementDivisor = ->
  if divisor > minimumDivisor
    divisor -= divisorStep
    resetStartingPoint()
    clearCanvas()

resetStartingPoint()
renderFractal()