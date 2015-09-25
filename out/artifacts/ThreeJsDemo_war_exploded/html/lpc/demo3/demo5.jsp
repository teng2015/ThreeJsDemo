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
            // 场景雾化
            scene.fog = new THREE.Fog(0xaaaaaa, 0.010, 200);

            // 创建透视相机
            var camera = new THREE.PerspectiveCamera(45, window.innerWidth/window.innerHeight, 0.1, 1000);
            // 设置相机位置
            camera.position.set(-20, 15, 45);
            // 旋转相机对象
            camera.lookAt(new THREE.Vector3(10, 0, 0));


            // 创建渲染器
            var renderer = new THREE.WebGLRenderer();
            // 设置渲染器背景
            renderer.setClearColorHex(0xaaaaff, 1.0);
            // 设置渲染大小
            renderer.setSize(window.innerWidth, window.innerHeight);
            // 开启阴影
            renderer.shadowMapEnabled = true;


            // 加载纹理
            var textureGrass = THREE.ImageUtils.loadTexture("../../../images/textures/ground/grasslight-big.jpg");

            textureGrass.wrapS = THREE.RepeatWrapping;

            textureGrass.wrapT = THREE.RepeatWrapping;

            textureGrass.repeat.set(4, 4);


            // 创建平面
            var plane = new THREE.Mesh(new THREE.PlaneGeometry(1000, 200, 20, 20),
                new THREE.MeshLambertMaterial({map: textureGrass})
            );
            // 开启阴影
            plane.receiveShadow = true;
            // 设置平面旋转
            plane.rotation.x = -0.5 * Math.PI;
            // 设置平面位置
            plane.position.set(15, 0, 0);
            scene.add(plane);

            // 创建立方体
            var cube = new THREE.Mesh(new THREE.CubeGeometry(4, 4, 4),
                new THREE.MeshLambertMaterial({color: 0xff3333})
            );
            // 开启阴影
            cube.castShadow = true;
            // 设置位置
            cube.position.set(-4, 3, 0);
            scene.add(cube);


            // 创建球体
            var sphere = new THREE.Mesh(new THREE.SphereGeometry(4, 25, 25),
                new THREE.MeshLambertMaterial({color: 0x7777ff})
            );
            // 开启阴影
            sphere.castShadow = true;
            // 设置球体位置
            sphere.position.set(10, 5, 10);
            scene.add(sphere);

            // 创建聚光
            var spotLight0 = new THREE.SpotLight(0xcccccc);
            // 设置聚光位置
            spotLight0.position.set(-40, 60, -10);
            // 设置聚光旋转对象
            spotLight0.lookAt(plane);
            scene.add(spotLight0);



            var target = new THREE.Object3D();
            target.position = new THREE.Vector3(5, 0, 0);

            // 创建半球光
            var hemisphereLight = new THREE.HemisphereLight(0x0000ff, 0x00ff00, 0.6);
            // 设置半球光位置
            hemisphereLight.position.set(0, 500, 0);
            // 设置半球光为不可见
            hemisphereLight.visible = false;
            scene.add(hemisphereLight);


            // 创建方向光
            var pointColor = "#ffffff";
            var spotLight = new THREE.DirectionalLight(pointColor);
            // 设置方向光位置
            spotLight.position.set(30, 10, -50);
            // 开启阴影
            spotLight.castShadow = true;
            // 设置从距离光源的那一点开始生成阴影
            spotLight.shadowCameraNear = 0.1;
            // 设置到距离光源的哪一点为止可以生成阴影
            spotLight.shadowCameraFar = 100;
            // 设置生成阴影的视场
            spotLight.shadowCameraFov = 50;
            // 设置光照的方向（指定目标）
            spotLight.target = plane;
            // 设置光源照射的距离
            spotLight.distance = 0;
            // 设置从距离光源的那一点开始生成阴影
            spotLight.shadowCameraNear = 2;
            // 设置到距离光源的哪一点为止可以生成阴影
            spotLight.shadowCameraFar = 200;
            // 相机左侧距离，不计算在范围之外的物体的阴影
            spotLight.shadowCameraLeft = -100;
            // 相机右侧距离，不计算在范围之外的物体的阴影
            spotLight.shadowCameraRight = 100;
            // 相机上侧距离，不计算在范围之外的物体的阴影
            spotLight.shadowCameraTop = 100;
            // 相机下侧距离，不计算在范围之外的物体的阴影
            spotLight.shadowCameraBottom = -100;
            // 阴影映射宽度
            spotLight.shadowMapWidth = 2048;
            // 阴影映射高度
            spotLight.shadowMapHeight = 2048;
            scene.add(spotLight);


            $("#WebGL-output").append(renderer.domElement);

            var step = 0;
            var invert = 1;
            var phase = 0;
            var controls = new function() {
                this.rotationSpeed = 0.03;
                this.bouncingSpeed = 0.03;

                this.hemisphere = false;
                this.groundColor = 0x00ff00;
                this.skyColor = 0x0000ff;
                this.intensity = 0.6;
            }

            var gui = new dat.GUI();
            gui.add(controls, "hemisphere").onChange(function(e) {
                hemisphereLight.visible = e;
            });
            gui.addColor(controls, "groundColor").onChange(function(e) {
                hemisphereLight.groundColor = new THREE.Color(e);
            });
            gui.addColor(controls, "skyColor").onChange(function(e) {
                hemisphereLight.color = new THREE.Color(e);
            });
            gui.add(controls, "intensity", 0, 5).onChange(function(e) {
                hemisphereLight.intensity = e;
            });

            render();

            function render() {
                stats.update();
                cube.rotation.x += controls.rotationSpeed;
                cube.rotation.y += controls.rotationSpeed;
                cube.rotation.z += controls.rotationSpeed;

                step += controls.bouncingSpeed;
                sphere.position.x = 20 + (10 * (Math.cos(step)));
                sphere.position.y = 2 + (10 * Math.abs(Math.sin(step)));

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