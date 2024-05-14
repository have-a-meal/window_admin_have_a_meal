# import cv2
# from pyzbar.pyzbar import decode
# import requests
# from tkinter import Tk, messagebox, Button

# def scan_qr_code():
#     cap = cv2.VideoCapture(0)
#     cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
#     cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)

#     # 사각형 영역 정의 (여기서는 화면 중앙에 가로 300px, 세로 300px의 사각형을 정의)
#     rect_width, rect_height = 300, 300
#     rect_start_point = (int(640/2 - rect_width/2), int(480/2 - rect_height/2))
#     rect_end_point = (int(640/2 + rect_width/2), int(480/2 + rect_height/2))
#     rect_color = (0, 255, 0) # 녹색 사각형
#     rect_thickness = 2

#     while True:
#         success, frame = cap.read()
#         if success:
#             # 화면에 사각형 그리기
#             cv2.rectangle(frame, rect_start_point, rect_end_point, rect_color, rect_thickness)
#             # 화면에 캠의 영상을 보여주기
#             cv2.imshow("QR Code Scanner", frame)

#             # 사각형 영역 내의 이미지를 추출
#             rect_img = frame[rect_start_point[1]:rect_end_point[1], rect_start_point[0]:rect_end_point[0]]

#             for qr_code in decode(frame):
#                 qr_data = qr_code.data.decode('utf-8')
#                 print("QR 코드 내용:", qr_data)

#                 # 잠시 기다려주세요 창 표시
#                 root = Tk()
#                 root.withdraw()  # 메인 창 숨기기
#                 messagebox.showinfo("진행 중", "API 처리 중입니다. 잠시 기다려주세요.")

#                 # API 호출
#                 response = requests.post('YOUR_API_ENDPOINT', data={'qr_data': qr_data})
#                 print("API 응답:", response.text)

#                 # 완료 메시지 창 표시
#                 messagebox.showinfo("완료", "처리가 완료되었습니다.")

#                 # 확인 버튼이 있는 창 표시
#                 def on_ok():
#                     root.destroy()  # 창 닫기

#                 root.deiconify()  # 메인 창 다시 보이기
#                 Button(root, text="확인", command=on_ok).pack()

#                 root.mainloop()

#                 return  # QR 코드 하나 처리 후 종료

#         if cv2.waitKey(1) & 0xFF == ord('q'):
#             break

#     cap.release()
#     cv2.destroyAllWindows()

# if __name__ == "__main__":
#     while True:
#         scan_qr_code()
#         print("다음 QR 코드를 스캔하세요.")

import cv2
from pyzbar.pyzbar import decode
import requests
from tkinter import Tk, messagebox, Button

def scan_qr_code():
    cap = cv2.VideoCapture(0)
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)

    # 사각형 영역 정의 (여기서는 화면 중앙에 가로 300px, 세로 300px의 사각형을 정의)
    rect_width, rect_height = 300, 300
    rect_start_point = (int(640/2 - rect_width/2), int(480/2 - rect_height/2))
    rect_end_point = (int(640/2 + rect_width/2), int(480/2 + rect_height/2))
    rect_color = (0, 255, 0) # 녹색 사각형
    rect_thickness = 2

    while True:
        success, frame = cap.read()
        if success:
            # 화면에 사각형 그리기
            cv2.rectangle(frame, rect_start_point, rect_end_point, rect_color, rect_thickness)
            # Display the camera's video on the screen
            cv2.imshow("QR Code Scanner", frame)

            # 사각형 영역 내의 이미지를 추출
            rect_img = frame[rect_start_point[1]:rect_end_point[1], rect_start_point[0]:rect_end_point[0]]

            for qr_code in decode(rect_img):
                qr_data = qr_code.data.decode('utf-8')
                print("QR 코드 내용:", qr_data)

                # 잠시 기다려주세요 창 표시
                root = Tk()
                root.withdraw()  # 메인 창 숨기기
                messagebox.showinfo("진행 중", "API 처리 중입니다. 잠시 기다려주세요.")

                # API 호출
                response = requests.post('YOUR_API_ENDPOINT', data={'qr_data': qr_data})
                print("API 응답:", response.text)

                # 완료 메시지 창 표시
                messagebox.showinfo("완료", "처리가 완료되었습니다.")

                # 확인 버튼이 있는 창 표시
                def on_ok():
                    root.destroy()  # 창 닫기

                root.deiconify()  # 메인 창 다시 보이기
                Button(root, text="확인", command=on_ok).pack()

                root.mainloop()

                return  # QR 코드 하나 처리 후 종료

        if cv2.waitKey(1) & 0xFF == ord('q'):  # 'q'를 누르면 함수에서 False 반환
                cap.release()
                cv2.destroyAllWindows()
                return False  # 메인 루프 종료를 위한 신호로 False 반환

    cap.release()
    cv2.destroyAllWindows()
    return True  # 정상 종료 시 True 반환

if __name__ == "__main__":
    continue_scanning = True
    while continue_scanning:
        continue_scanning = scan_qr_code()  # scan_qr_code()의 반환값에 따라 루프 계속 여부 결정
        if continue_scanning:
            print("다음 QR 코드를 스캔하세요.")
        else:
            print("프로그램을 종료합니다.")
