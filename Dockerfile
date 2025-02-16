FROM ubuntu

RUN  apt update &&  apt upgrade -y  &&  apt install tmux git -y

CMD [ "bash" ]