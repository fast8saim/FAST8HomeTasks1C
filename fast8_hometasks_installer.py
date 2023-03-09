import tkinter
from tkinter import ttk
from tkinter import filedialog
import subprocess
import os

def run_command(command):
    process = subprocess.Popen(command)
    process.wait()

def check_create_dir(path):
    if os.path.exists(path) == False:
        os.mkdir(path)

def unpack_platform():
    platformfile = "windows64full_8_3_23_1596.rar"
    archiver = "C:\\Program Files\\7-Zip\\7z.exe"
    run_command(f'{archiver} x -o"platform" {platformfile}')

def check_config():
    program_data_path = os.environ.get('ALLUSERSPROFILE')

    check_create_dir(f'{program_data_path}\\1C')
    check_create_dir(f'{program_data_path}\\1C\\1CEStart')

    config_1cestart_path = f'{program_data_path}\\1C\\1CEStart\\1cestart.cfg'
    if os.path.exists(config_1cestart_path) == False:
        config_file = open(config_1cestart_path, "w")
        config_file.write("InstallComponents=DESIGNERALLCLIENTS=1 THINCLIENTFILE=0 THINCLIENT=0 WEBSERVEREXT=0 SERVER=1 CONFREPOSSERVER=0 CONVERTER77=0 SERVERCLIENT=0 ADMINISTRATIONFUNC=0 COPYTHINCLIENTDST=0 LANGUAGES=RU")
        config_file.close()

def setup_platform():
    run_command(f'platform\\setup.exe /S /ALLUSERS')

def create_infobase(ibcmd, base_dir, base_name):
    run_command(f'{ibcmd} server config init --database-path={base_dir} --name={base_name} --http-base=/{base_name} --out="{base_name}\\{base_name}.yml"')
    run_command(f'{ibcmd} infobase create --config="{base_name}\\{base_name}.yml" --load="1Cv8.cf" --data="{base_dir}"')
    run_command(f'{ibcmd} infobase config apply --database-path={base_dir} --data={base_dir} --force')

def start_service(base_name, ibcrv, base_dir):
    run_command(f'sc stop {base_name}')
    run_command(f'sc delete {base_name}')
    run_command(f'sc create {base_name} binPath= "{ibcrv} --service --config=C:\\WORK\\{base_name}\\{base_name}.yml --data={base_dir}" start= auto displayname= {base_name}')
    run_command(f'sc start {base_name}')

def create_checkbox(form, text, variable, column, row):
    checkbox = ttk.Checkbutton(form)
    checkbox['text'] = text
    checkbox['variable'] = variable
    checkbox.grid(column=column, row=row, sticky='w')

def create_button(form, button_text, button_column, button_row, button_width, button_command):
    button = ttk.Button(form)
    button['width'] = button_width
    button['text'] = button_text
    button['command'] = button_command
    button.grid(column=button_column, row=button_row)

def choose_platform_file():
    return filedialog.askopenfilename(title='Выберите файл дистрибутива платформы')

def dummy():
    pass

#unpack_platform()
#check_config()
#setup_platform()

ibcmd = 'C:\\Program Files\\1cv8\\8.3.23.1596\\bin\\ibcmd.exe'
ibcrv = 'C:\\Program Files\\1cv8\\8.3.23.1596\\bin\\ibsrv.exe'
base_dir = 'C:\\WORK\\BASE'
base_name = 'FAST8Tasks'
#create_infobase(ibcmd, base_dir, base_name)
#start_service(base_name, ibcrv, base_dir)

root = tkinter.Tk()
root.title("FAST8 установка")
form = ttk.Frame(root, padding=5)
form.grid()

set_download_7zip = True
set_setup_7zip = True
set_unpack_platform = True
set_setup_platform = True
set_create_infobase = True
set_create_service = True
create_checkbox(form, 'Скачать 7zip', set_download_7zip, 1, 1)
create_checkbox(form, 'Установить 7zip', set_setup_7zip, 1, 2)
create_checkbox(form, 'Распаковать дистрибутив платформы', set_unpack_platform, 1, 3)
create_checkbox(form, 'Установить платформу', set_setup_platform, 1, 4)
create_checkbox(form, 'Создать информационную базу', set_create_infobase, 1, 5)
create_checkbox(form, 'Создать службу автономного сервера', set_create_service, 1, 6)
create_button(form, "Скачать 7zip", 2, 1, 30, dummy)
create_button(form, "Установить 7zip", 2, 2, 30, dummy)
create_button(form, "Распаковать дистрибутив платформы", 2, 3, 30, unpack_platform)
create_button(form, "Установить платформу", 2, 4, 30, setup_platform)
create_button(form, "Создать информационную базу", 2, 5, 30, dummy)
create_button(form, "Создать службу автономного сервера", 2, 6, 30, dummy)
create_button(form, "Выполнить все операции", 2, 7, 30, choose_platform_file)
set_platform_dir = ''


root.mainloop()