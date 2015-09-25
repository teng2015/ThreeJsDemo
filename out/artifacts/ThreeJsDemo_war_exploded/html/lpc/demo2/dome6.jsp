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
            // 设置相机位置
            camera.position.set(-30, 40, 30);
            camera.lookAt(scene.position);

            // 创建渲染器
            var renderer = new THREE.WebGLRenderer();
            renderer.setClearColorHex(0xEEEEEE, 0.1);
            // 设置宽度和高度
            renderer.setSize(window.innerWidth, window.innerHeight);
            // 是否允许阴影映射
            renderer.shadowMapEnabled = true;

            // 创建立方体
            var plane = new THREE.Mesh(new THREE.PlaneGeometry(60, 40, 1, 1),
                new THREE.MeshLambertMaterial({
                    color: 0xffffff
                })
            );
            // 是否支持阴影覆盖
            plane.receiveShadow = true;
            // 设置旋转
            plane.rotation.x = -0.5 * Math.PI;
            plane.position.set(0, 0, 0);
            scene.add(plane);

            // 创建光源（环境光）
            var ambientLight = new THREE.AmbientLight(0x0c0c0c);
            scene.add(ambientLight);

            // 创建光源（聚光灯光源）
            var spotLight = new THREE.SpotLight(0xffffff);
            spotLight.position.set(-40, 60, 20);
            spotLight.castShadow = true;
            scene.add(spotLight);

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;

            var controls = new function () {
                this.scaleX = 1;
                this.scaleY = 1;
                this.scaleZ = 1;

                this.positionX = 0;
                this.positionY = 4;
                this.positionZ = 0;

                this.rotationX = 0;
                this.rotationY = 0;
                this.rotationZ = 0;
                this.scale = 1;

                this.translateX = 0;
                this.translateY = 0;
                this.translateZ = 0;

                this.translate = function () {
                    cube.translateX(this.translateX);
                    cube.translateY(this.translateX);
                    cube.translateZ(this.translateX);

                    this.positionX = cube.position.x;
                    this.positionY = cube.position.y;
                    this.positionZ = cube.position.z;
                }
            }

            var material = new THREE.MeshLambertMaterial({color: 0x44ff44});
            var geom = new THREE.CubeGeometry(5, 8, 3);
            var cube = new THREE.Mesh(geom, material);
            cube.position.y = 4;
            cube.castShadow = true;
            scene.add(cube);

            var gui = new dat.GUI();
            guiScale = gui.addFolder('scale');
            guiScale.add(controls,'scaleX',0,5);
            guiScale.add(controls,'scaleY',0,5);
            guiScale.add(controls,'scaleZ',0,5);

            guiPosition = gui.addFolder('position');
            var contX = guiPosition.add(controls,'positionX',-10,10);
            var contY = guiPosition.add(controls,'positionY',-4,20);
            var contZ = guiPosition.add(controls,'positionZ',-10,10);

            contX.listen();
            contX.onChange(function(value) {
                cube.position.x=controls.positionX;
            });

            contY.listen();
            contY.onChange(function(value) {
                cube.position.y=controls.positionY;
            });

            contZ.listen();
            contZ.onChange(function(value) {
                cube.position.z=controls.positionZ;
            });

            guiRotation = gui.addFolder('rotation');
            guiRotation.add(controls, 'rotationX', -4, 4);
            guiRotation.add(controls, 'rotationY', -4, 4);
            guiRotation.add(controls, 'rotationZ', -4, 4);

            guiTranslate = gui.addFolder('translate');
            guiTranslate.add(controls, 'translateX', -10, 10);
            guiTranslate.add(controls, 'translateY', -10, 10);
            guiTranslate.add(controls, 'translateZ', -10, 10);
            guiTranslate.add(controls, 'translate');

            render();

            function render() {
                stats.update();

                cube.rotation.x = controls.rotationX;
                cube.rotation.y = controls.rotationY;
                cube.rotation.z = controls.rotationZ;

                cube.scale.set(controls.scaleX, controls.scaleY, controls.scaleZ);

                requestAnimationFrame(render);
                renderer.render(scene, camera);
            }

            function initStats() {
                var stats = new Stats();
                stats.setMode(0);
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