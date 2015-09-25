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
            camera.position.set(-20, 30, 40);
            camera.lookAt(new THREE.Vector3(10, 0, 0));


            var renderer;
            var webGLRenderer = new THREE.WebGLRenderer();
            webGLRenderer.setClearColorHex(0xEEEEEE, 1.0);
            webGLRenderer.setSize(window.innerWidth, window.innerHeight);
            webGLRenderer.shadowMapEnabled = true;


            var canvasRenderer = new THREE.CanvasRenderer();
            canvasRenderer.setSize(window.innerWidth, window.innerHeight);
            renderer = webGLRenderer;


            var groundGeom = new THREE.PlaneGeometry(100, 100, 4, 4);
            var groundMesh = new THREE.Mesh(groundGeom, new THREE.MeshBasicMaterial({color: 0x555555}));
            groundMesh.rotation.x = -Math.PI / 2;
            groundMesh.position.y = -20;
            scene.add(groundMesh);


            var sphereGeometry = new THREE.SphereGeometry(14, 20, 20);
            var cubeGeometry = new THREE.CubeGeometry(15, 15, 15);
            var planeGeometry = new THREE.PlaneGeometry(14, 14, 4, 4);

            var meshMaterial = new THREE.MeshPhongMaterial({color: 0x7777ff});
            var sphere = new THREE.Mesh(sphereGeometry, meshMaterial);
            var cube = new THREE.Mesh(cubeGeometry, meshMaterial);
            var plane = new THREE.Mesh(planeGeometry, meshMaterial);

            sphere.position.set(0, 3, 2);
            cube.position = sphere.position;
            plane.position = sphere.position;
            scene.add(cube);

            var spotLight = new THREE.SpotLight(0xffffff);
            spotLight.position.set(-0, 30, 60);
            spotLight.castShadow = true;
            spotLight.intensity = 0.6;
            scene.add(spotLight);

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;
            var controls = new function() {
                this.rotationSpeed = 0.02;
                this.bouncingSpeed = 0.03;

                this.opacity = meshMaterial.opacity;
                this.transparent = meshMaterial.transparent;
                this.overdraw = meshMaterial.overdraw;
                this.visible = meshMaterial.visible;
                this.emissive = meshMaterial.emissive.getHex();
                this.ambient = meshMaterial.ambient.getHex();
                this.specular = meshMaterial.specular.getHex();
                this.shininess = meshMaterial.shininess;
                this.side = "front";

                this.color = meshMaterial.color.getStyle();
                this.selectedMesh = "cube";
            }


            var gui = new dat.GUI();
            var spGui = gui.addFolder("Mesh");
            spGui.add(controls, "opacity", 0, 1).onChange(function(e) {
                meshMaterial.opacity = e;
            });
            spGui.add(controls, "transparent").onChange(function(e) {
                meshMaterial.transparent = e;
            });
            spGui.add(controls, "visible").onChange(function(e) {
                meshMaterial.visible = e;
            });
            spGui.addColor(controls, "ambient").onChange(function(e) {
                meshMaterial.ambient = new THREE.Color(e);
            });
            spGui.addColor(controls, "emissive").onChange(function(e) {
                meshMaterial.emissive = new THREE.Color(e);
            });
            spGui.addColor(controls, "specular").onChange(function(e) {
                meshMaterial.specular = new THREE.Color(e);
            });
            spGui.add(controls, "shininess", 0, 200).onChange(function(e) {
                meshMaterial.shininess = e;
            });
            spGui.add(controls, "side", ['front', 'back', 'double']).onChange(function(e) {
                console.log(e);
                switch (e) {
                    case "front":
                        meshMaterial.side = THREE.FrontSide;
                        break;
                    case "back":
                        meshMaterial.side = THREE.BackSide;
                        break;
                    case "double":
                        meshMaterial.side = THREE.DoubleSide;
                        break;
                }
                meshMaterial.needsUpdate = true;
                console.log(meshMaterial);
            });
            spGui.addColor(controls, "color").onChange(function(e) {
                meshMaterial.color.setStyle(e);
            });
            spGui.add(controls, "selectedMesh", ['cube', 'sphere', 'plane']).onChange(function(e) {
                scene.remove(cube);
                scene.remove(sphere);
                scene.remove(plane);
                switch (e) {
                    case "cube":
                        scene.add(cube);
                        break;
                    case "sphere":
                        scene.add(sphere);
                        break;
                    case "plane":
                        scene.add(plane);
                        break;
                }
                scene.add(e);
            });

            render();

            function render() {
                stats.update();
                cube.rotation.y = step += 0.01;
                plane.rotation.y = step;
                sphere.rotation.y = step;

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