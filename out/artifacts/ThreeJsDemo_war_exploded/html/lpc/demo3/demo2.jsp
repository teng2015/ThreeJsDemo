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

            // 创建场景
            var scene = new THREE.Scene();

            // 创建透视相机
            var camera = new THREE.PerspectiveCamera(45, window.innerWidth/window.innerHeight, 0.1, 1000);
            // 设置相机的位置
            camera.position.set(-25, 30, 25);
            // 开启阴影
            camera.shadowMapEnabled = true;
            camera.lookAt(new THREE.Vector3(10, 0, 0));

            // 创建渲染器
            var renderer = new THREE.WebGLRenderer();
            // 设置默认背景颜色
            renderer.setClearColorHex(0xEEEEEE, 1.0);
            // 设置渲染范围
            renderer.setSize(window.innerWidth, window.innerHeight);

            // 创建平面
            var plane = new THREE.Mesh(new THREE.PlaneGeometry(60, 20, 1, 1),
                new THREE.MeshLambertMaterial({color: 0xffffff})
            );
            // 设置平面旋转
            plane.rotation.x = -0.5 * Math.PI;
            // 设置平面位置
            plane.position.set(15, 0, 0);
//            plane.receiveShadow = true;
            scene.add(plane);

            // 创建立方体
            var cube = new THREE.Mesh(new THREE.CubeGeometry(4, 4, 4),
                new THREE.MeshLambertMaterial({color: 0xff7777})
            );
            // 设置立方体位置
            cube.position.set(-4, 3, 0);
            // 开启阴影
            cube.castShadow = true;
            scene.add(cube);

            // 创建球体
            var sphere = new THREE.Mesh(new THREE.SphereGeometry(4, 20, 20),
                new THREE.MeshLambertMaterial({color: 0x7777ff})
            );
            // 设置球体位置
            sphere.position.set(20, 0, 2);
            // 开启阴影
            sphere.castShadow = true;
            scene.add(sphere);

            // 创建环境光
            var ambiColor = "#0c0c0c";
            var ambientLight = new THREE.AmbientLight(ambiColor);
            scene.add(ambientLight);

            // 创建聚光
            var spotLight = new THREE.SpotLight(0xffffff);
            spotLight.position.set(-40, 60, -10);
            spotLight.castShadow = true;

            // 创建点光-射线
            var pointColor = "#ccffcc";
            var pointLight = new THREE.PointLight(pointColor);
            pointLight.distance = 100;
            scene.add(pointLight);


            var sphereLightMesh = new THREE.Mesh(new THREE.SphereGeometry(0.2),
                new THREE.MeshBasicMaterial({color: 0xac6c25})
            );
            sphereLightMesh.castShadow = true;
            sphereLightMesh.position = new THREE.Vector3(3, 5, 3);
            scene.add(sphereLightMesh);

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;

            var invert = 1;
            var phase = 0;
            var controls = new function() {
                this.rotationSpeed = 0.03;
                this.bouncingSpped = 0.03;
                this.ambientColor = ambiColor;
                this.pointColor = pointColor;
                this.intensity = 1;
                this.distance = 100;
            }

            var gui = new dat.GUI();
            gui.addColor(controls, "ambientColor").onChange(function(e) {
               ambientLight.color = new THREE.Color(e);
            });

            gui.addColor(controls, "pointColor").onChange(function(e) {
               pointLight.color = new THREE.Color(e);
            });

            gui.add(controls, 'intensity', 0, 3).onChange(function(e) {
                pointLight.intensity = e;
            });

            gui.add(controls, "distance", 0, 100).onChange(function(e) {
                pointLight.distance = e;
            });

            render();

            function render() {
                stats.update();
                cube.rotation.x += controls.rotationSpeed;
                cube.rotation.y += controls.rotationSpeed;
                cube.rotation.z += controls.rotationSpeed;

                step += controls.bouncingSpped;
                sphere.position.x = 20 + (10 * (Math.cos(step)));
                sphere.position.y = 2 + (10 * Math.abs(Math.sin(step)));

                if (phase > 2 * Math.PI) {
                    invert = invert * -1;
                    phase -= 2 * Math.PI;
                } else {
                    phase += controls.rotationSpeed;
                }

                sphereLightMesh.position.z = +(7 * (Math.sin(phase)));
                sphereLightMesh.position.x = +(14 * (Math.cos(phase)));

                if (invert < 0) {
                    var pivot = 14;
                    sphereLightMesh.position.x = (invert * (sphereLightMesh.position.x - pivot)) + pivot;
                }

                pointLight.position = sphereLightMesh.position;

                requestAnimationFrame(render);
                renderer.render(scene, camera);
            }


            function initStats() {

                var stats = new Stats();

                stats.setMode(0); // 0: fps, 1: ms

                // Align top-left
                stats.domElement.style.position = 'absolute';
                stats.domElement.style.left = '0px';
                stats.domElement.style.top = '0px';

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