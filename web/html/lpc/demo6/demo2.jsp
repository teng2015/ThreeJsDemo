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
            camera.position.set(-30, 40, 50);
            camera.lookAt(new THREE.Vector3(10, 0, 0));

            var renderer = new THREE.WebGLRenderer();
            renderer.setClearColorHex(0xEEEEEE, 1.0);
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.shadowMapEnabled = true;

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;
            var spGroup;
            var latheMesh;
            generatePoints(12, 2, 2 * Math.PI);

            var controls = new function() {
                this.segments = 12;
                this.phiStart = 0;
                this.phiLength = 2 * Math.PI;

                this.redraw = function() {
                    scene.remove(spGroup);
                    scene.remove(latheMesh);
                    generatePoints(controls.segments, controls.phiStart, controls.phiLength);
                };
            }

            var gui = new dat.GUI();
            gui.add(controls, "segments", 0, 50).step(1).onChange(controls.redraw);
            gui.add(controls, "phiStart", 0, 2 * Math.PI).onChange(controls.redraw);
            gui.add(controls, "phiLength", 0, 2 * Math.PI).onChange(controls.redraw);

            render();

            function generatePoints(segments, phiStart, phiLength) {
                var points = [];
                var height = 5;
                var count = 30;
                for (var i=0; i<count; i++) {
                    points.push(new THREE.Vector3((Math.sin(i*0.2) + Math.cos(i * 0.3)) * height + 12, 0, (i - count) + count / 2))
                }

                spGroup =  new THREE.Object3D();
                var material = new THREE.MeshBasicMaterial({color:0xff0000, transparent: false});
                points.forEach(function(point) {
                    var spGeom = new THREE.SphereGeometry(0.2);
                    var spMesh = new THREE.Mesh(spGeom, material);
                    spMesh.position = point;
                    spGroup.add(spMesh);
                });

                scene.add(spGroup);

                var latheGeometry = new THREE.LatheGeometry(points, segments, phiStart, phiLength);
                latheMesh = createMesh(latheGeometry);
                scene.add(latheMesh);
            }

            function createMesh(geom) {
                var meshMaterial = new THREE.MeshNormalMaterial();
                meshMaterial.side = THREE.DoubleSide;
                var wireFrameMat = new THREE.MeshBasicMaterial();
                wireFrameMat.wireframe = true;
                var mesh = THREE.SceneUtils.createMultiMaterialObject(geom, [meshMaterial, wireFrameMat]);
                return mesh;
            }

            function render() {
                stats.update();
                spGroup.rotation.x = step;
                latheMesh.rotation.x = step += 0.01;
                requestAnimationFrame(render);
                renderer.render(scene, camera);
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

        })

    </script>

</head>
<body>

    <div id="Stats-output"></div>

    <div id="WebGL-output"></div>

</body>
</html>