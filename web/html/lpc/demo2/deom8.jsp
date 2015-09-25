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

    <script type="text/javascript">

        $(function() {

            var stats = initStats();
            // 创建场景
            var scene = new THREE.Scene();

            // 创建相机
            var camera = new THREE.PerspectiveCamera(45, window.innerWidth/window.innerHeight, 0.1, 1000);
            camera.position.set(120, 60, 180);
            camera.lookAt(scene.position);

            // 创建渲染器
            var renderer = new THREE.WebGLRenderer();
            renderer.setClearColorHex(0xEEEEEE, 1.0);
            renderer.setSize(window.innerWidth, window.innerHeight);

            // 创建立方体
            var planeGeometry = new THREE.PlaneGeometry(180, 180);
            var planeMaterial = new THREE.MeshLambertMaterial({color: 0xffffff});
            var plane = new THREE.Mesh(planeGeometry, planeMaterial);
            plane.rotation.x = -0.5 * Math.PI;
            plane.position.set(0, 0, 0);
            scene.add(plane);

            var cubeGeometry = new THREE.CubeGeometry(4, 4, 4);
            var cubeMaterial = new THREE.MeshLambertMaterial({color: 0x00ee22});
            for (var i=0; i<(planeGeometry.height / 5); i++) {
                for (var j=0; j<(planeGeometry.width / 5); j++) {
                    var cube = new THREE.Mesh(cubeGeometry, cubeMaterial);
                    cube.position.x = -((planeGeometry.width) / 2) + 2 + (j * 5);
                    cube.position.y = 2;
                    cube.position.z = -((planeGeometry.height) / 2) + 2 + (i * 5);
                    scene.add(cube);
                }
            }

            var lookAtGeom = new THREE.SphereGeometry(2);
            var lookAtMesh = new THREE.Mesh(lookAtGeom, new THREE.MeshLambertMaterial({color: 0xff0000}));
            scene.add(lookAtMesh);

            // 创建平行光
            var directionalLight = new THREE.DirectionalLight(0xffffff, 0.7);
            directionalLight.position.set(-20, 40, 60);
            scene.add(directionalLight);

            // 创建环境光
            var ambientLight = new THREE.AmbientLight(0x292929);
            scene.add(ambientLight);

            $("#WebGL-output").append(renderer.domElement);
            var step=0;

            var controls = new function() {
                this.perspective = "Perspective";
                this.switchCamera = function() {
                    if (camera instanceof THREE.PerspectiveCamera) {
                        camera = new THREE.OrthographicCamera(window.innerWidth / -16, window.innerWidth / 16, window.innerHeight / 16, window.innerHeight / -16, -200, 500);
                        camera.position.set(2, 1, 3);
                        camera.lookAt(scene.position);
                        this.perspective = "Orthographic";
                    } else {
                        camera = new THREE.PerspectiveCamera(45, window.innerWidth/window.innerHeight, 0.1, 1000);
                        camera.position.set(120, 60, 180);
                        camera.lookAt(scene.position);
                        this.perspective = "Perspective";
                    }
                }
            }

            var gui = new dat.GUI();
            gui.add(controls, "switchCamera");
            gui.add(controls, "perspective").listen();

            render();

            var step = 0;

            function render() {
                stats.update();
                step += 0.02;
                if (camera instanceof THREE.PerspectiveCamera) {
                    var x = 10 + (100 * (Math.sin(step)));
                    camera.lookAt(new THREE.Vector3(x, 10, 0));
                    lookAtMesh.position = new THREE.Vector3(x, 10, 0);
                } else {
                    var x = Math.cos(step);
                    camera.lookAt(new THREE.Vector3(x, 0, 0));
                    lookAtMesh.position = new THREE.Vector3(x, 10, 0);
                }

                requestAnimationFrame(render);
                renderer.render(scene, camera);
            }

            function initStats(){
                var stats = new Stats();
                stats.setMode(0);

                stats.domElement.style.position = "absolute";
                stats.domElement.left = "0px";
                stats.domElement.top = "0px";

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