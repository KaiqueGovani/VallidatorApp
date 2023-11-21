
window.onload = () => {
    const btnSair = document.getElementById('btnSair');
    if(btnSair) btnSair.addEventListener('click', async (event) => {
        event.preventDefault();
        try {
            await fetch('/usuarios/logout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                credentials: 'include'
            });
    
            window.location.href = '../login';
        } catch (error) {
            console.error(error);
        }
    });
}




