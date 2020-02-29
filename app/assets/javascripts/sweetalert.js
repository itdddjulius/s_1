function sweetalert(message, status) {
  const Toast = Swal.mixin({
    toast: true,
    position: 'top',
    showConfirmButton: false,
    timer: 3000
  })

  Toast.fire({
    icon: status == 'error' ? 'error' : 'success',
    title: message
  })
}
