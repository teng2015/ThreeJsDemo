<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/three.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.2.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/dat.gui.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/stats.js"></script>

    <title>Insert title here</title>

    <style>
        body {
            /* set margin to 0 and overflow to hidden, to go fullscreen */
            margin: 0;
            overflow: hidden;
        }
    </style>

    <script type="text/javascript">

        $(function() {

            var stats = initStats();

            var scene = new THREE.Scene();

            var camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
            camera.position.set(-30, 40, 30);
            camera.lookAt(scene.position);


            var renderer = new THREE.WebGLRenderer();
            renderer.setClearColorHex(0xAAAAAA, 1.0);
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.shadowMapEnabled = true;


            var ambientLight = new THREE.AmbientLight(0x0c0c0c);
            scene.add(ambientLight);


            var spotLight = new THREE.SpotLight(0xffffff);
            spotLight.position.set(-40, 60, -10);
            spotLight.castShadow = true;
            scene.add(spotLight);


            var points = gosper(4, 60);
            var lines = new THREE.Geometry();
            var colors = [];
            var i = 0;
            points.forEach(function(e) {
               lines.vertices.push(new THREE.Vector3(e.x, e.z, e.y));
                colors[i] = new THREE.Color(0xffffff);
                colors[i].setHSL(e.x / 100 + 0.5, (e.y * 20) / 300, 0.8);
                i++;
            });

            lines.colors = colors;
            lines.computeLineDistances();
            var material = new THREE.LineDashedMaterial({vertexColors: true, color: 0xffffff, dashSize: 3, gapSize: 1, scale: 0.1});

            var line = new THREE.Line(lines, material);
            line.position.set(25, -30, -60);
            scene.add(line);

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;

            render();

            function render() {
                stats.update();
                line.rotation.z = step += 0.01;
                requestAnimationFrame(render);
                renderer.render(scene, camera);
            }

            function gosper(a, b) {

                var turtle = [0, 0, 0];
                var points = [];
                var count = 0;

                rg(a, b, turtle);


                return points;

                function rt(x) {
                    turtle[2] += x;
                }

                function lt(x) {
                    turtle[2] -= x;
                }

                function fd(dist) {
//                ctx.beginPath();
                    points.push({x: turtle[0], y: turtle[1], z: Math.sin(count) * 5});
//                ctx.moveTo(turtle[0], turtle[1]);

                    var dir = turtle[2] * (Math.PI / 180);
                    turtle[0] += Math.cos(dir) * dist;
                    turtle[1] += Math.sin(dir) * dist;

                    points.push({x: turtle[0], y: turtle[1], z: Math.sin(count) * 5});
//                ctx.lineTo(turtle[0], turtle[1]);
//                ctx.stroke();

                }

                function rg(st, ln, turtle) {

                    st--;
                    ln = ln / 2.6457;
                    if (st > 0) {
//                    ctx.strokeStyle = '#111';
                        rg(st, ln, turtle);
                        rt(60);
                        gl(st, ln, turtle);
                        rt(120);
                        gl(st, ln, turtle);
                        lt(60);
                        rg(st, ln, turtle);
                        lt(120);
                        rg(st, ln, turtle);
                        rg(st, ln, turtle);
                        lt(60);
                        gl(st, ln, turtle);
                        rt(60);
                    }
                    if (st == 0) {
                        fd(ln)
                        rt(60)
                        fd(ln)
                        rt(120)
                        fd(ln)
                        lt(60)
                        fd(ln)
                        lt(120)
                        fd(ln)
                        fd(ln)
                        lt(60)
                        fd(ln)
                        rt(60)
                    }
                }

                function gl(st, ln, turtle) {
                    st--;
                    ln = ln / 2.6457;
                    if (st > 0) {
//                    ctx.strokeStyle = '#555';
                        lt(60);
                        rg(st, ln, turtle);
                        rt(60);
                        gl(st, ln, turtle);
                        gl(st, ln, turtle);
                        rt(120);
                        gl(st, ln, turtle);
                        rt(60);
                        rg(st, ln, turtle)
                        lt(120)
                        rg(st, ln, turtle);
                        lt(60);
                        gl(st, ln, turtle);
                    }
                    if (st == 0) {
                        lt(60);
                        fd(ln);
                        rt(60);
                        fd(ln);
                        fd(ln);
                        rt(120)
                        fd(ln);
                        rt(60);
                        fd(ln);
                        lt(120);
                        fd(ln);
                        lt(60);
                        fd(ln);
                    }
                }
            }

            function initStats() {
                var stats = new Stats();
                stats.setMode(0);
                stats.domElement.style.position = "absolute";
                stats.domElement.style.left = "0px";
                stats.domElement.style.top = "0px";
                $("#Stats-output").append(stats.domElement);
                return stats;
            }


        });


    </script>

</head>
<body>

    <div id="Stats-output"></div>

    <div id="WebGL-output"></div>

</body>
</html>