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

            camera.position.set(-20, 30, 20);

            camera.lookAt(scene.position);

            var renderer = new THREE.WebGLRenderer();
            renderer.setClearColorHex(0xEEEEEE, 1.0);
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.shadowMapEnabled = false;

            var plane = new THREE.Mesh(new THREE.PlaneGeometry(60, 40, 1, 1),
                new THREE.MeshLambertMaterial({color: 0xffffff})
            );
            plane.rotation.x = -0.5 * Math.PI;
            plane.position.set(0, -2, 0);
            plane.receiveShadow = true;
            scene.add(plane);


            var spotLight = new THREE.SpotLight(0xffffff);
            spotLight.position.set(-40, 60, -10);
            spotLight.castShadow = true;
            scene.add(spotLight);

            $("#WebGL-output").append(renderer.domElement);

            var group = new THREE.Mesh();
            var mats = [];
            mats.push(new THREE.MeshBasicMaterial({color: 0x009e60}));
            mats.push(new THREE.MeshBasicMaterial({color: 0x0051ba}));
            mats.push(new THREE.MeshBasicMaterial({color: 0xffd500}));
            mats.push(new THREE.MeshBasicMaterial({color: 0xff5800}));
            mats.push(new THREE.MeshBasicMaterial({color: 0xC41E3A}));
            mats.push(new THREE.MeshBasicMaterial({color: 0xffffff}));
            var faceMaterial = new THREE.MeshFaceMaterial(mats);

            for (var i=0; i<3; i++) {
                for (var j=0; j<3; j++) {
                    for (var k=0; k<3; k++) {
                        var cubeGeom = new THREE.CubeGeometry(2.9, 2.9, 2.9);
                        var cube = new THREE.Mesh(cubeGeom, faceMaterial);
                        cube.position = new THREE.Vector3(i * 3 - 3, j * 3, k * 3 - 3);
                        group.add(cube);
                    }
                }
            }
            scene.add(group);

            var step = 0;
            var controls = new function() {
                this.rotationSpeed = 0.02;
                this.numberOfObjects = scene.children.length;
            }

            var gui = new dat.GUI();
            gui.add(controls, "rotationSpeed", 0, 10);

            render();

            function render() {
                stats.update();
                group.rotation.y = step += 0.01;
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

        });


    </script>

</head>
<body>

    <div id="Stats-output"></div>

    <div id="WebGL-output"></div>

</body>
</html>